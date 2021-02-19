import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:wedding_app/utils/random_string.dart';
import 'package:wedding_app/utils/validations.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InviteEmailBloc extends Bloc<InviteEmailEvent, InviteEmailState> {
  final InviteEmailRepository _inviteEmailRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;

  InviteEmailBloc({@required InviteEmailRepository inviteEmailRepository})
      : assert(inviteEmailRepository != null),
        _inviteEmailRepository = inviteEmailRepository,
        super(InviteEmailLoading());

  @override
  Stream<InviteEmailState> mapEventToState(InviteEmailEvent event) async* {
    if (event is SendEmailButtonSubmitted) {
      yield* _mapSendEmailSubmittedToState(event);
    }
  }

  Stream<InviteEmailState> _mapSendEmailSubmittedToState(
      SendEmailButtonSubmitted event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String weddingId = prefs.getString("wedding_id");

    String code = getRandomString(6);

    User user = auth.currentUser;
    String from = user.email;
    String title = "Bạn nhận được lời mời tham dự chỉnh sửa đám cưới";
    String body = "";
    try {
      yield InviteEmailProcessing();
      if (!Validation.isEmailValid(event.email)) {
        yield InviteEmailError(message: "Email không đúng");
      } else {
        InviteEmail inviteEmail = new InviteEmail(
            from: from,
            date: DateTime.now(),
            to: event.email,
            code: code,
            weddingId: weddingId,
            title: title,
            body: body);
        await _sendEmail(inviteEmail).then(
            (value) => _inviteEmailRepository.createInviteEmail(inviteEmail));

        yield InviteEmailSuccess(message: "Thành công");
      }
    } catch (e) {
      print(e);
      yield InviteEmailError(message: "Có lỗi xảy ra");
    }
  }

  Future<void> _sendEmail(InviteEmail inviteEmail) async {
    String username = "linhlche130970@fpt.edu.vn";
    // Setting up Google SignIn
    final googleSignIn = GoogleSignIn.standard(
        scopes: ['email', 'https://www.googleapis.com/auth/gmail.send']);

    // Signing in
    final account = await googleSignIn.signIn();

    if (account == null) {
      // User didn't authorize
      return;
    }

    final auth = await account.authentication;

    // Creating SMTP server from the access token
    SmtpServer smtpServer = gmailSaslXoauth2(username, auth.accessToken);

    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add(inviteEmail.to)
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = inviteEmail.title
      ..html = inviteEmail.code;
    final sendReport = await send(message, smtpServer);
  }
  // Create our message.

}
