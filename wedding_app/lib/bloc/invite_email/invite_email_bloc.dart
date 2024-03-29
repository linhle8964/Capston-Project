import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:wedding_app/repository/user_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/const/message_const.dart';
import 'package:wedding_app/utils/random_string.dart';
import 'package:wedding_app/utils/validations.dart';
import 'package:wedding_app/const/email_password.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class InviteEmailBloc extends Bloc<InviteEmailEvent, InviteEmailState> {
  final InviteEmailRepository _inviteEmailRepository;
  final UserRepository _userRepository;
  final UserWeddingRepository _userWeddingRepository;

  InviteEmailBloc(
      {@required InviteEmailRepository inviteEmailRepository,
      @required UserRepository userRepository,
      @required UserWeddingRepository userWeddingRepository})
      : assert(inviteEmailRepository != null),
        assert(userRepository != null),
        assert(userWeddingRepository != null),
        _inviteEmailRepository = inviteEmailRepository,
        _userRepository = userRepository,
        _userWeddingRepository = userWeddingRepository,
        super(InviteEmailLoading());

  @override
  Stream<InviteEmailState> mapEventToState(InviteEmailEvent event) async* {
    if (event is SendEmailButtonSubmitted) {
      yield* _mapSendEmailSubmittedToState(event);
    } else if (event is SubmittedCode) {
      yield* _mapSubmittedCodeToState(event);
    }
  }

  Stream<InviteEmailState> _mapSendEmailSubmittedToState(
      SendEmailButtonSubmitted event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String weddingId = prefs.getString("wedding_id");

    String code = getRandomString(6);

    User user = await _userRepository.getUser();
    String from = user.email;
    String to = event.email;
    String title = SenderEmailPassword.title;
    String body = "<h1>$code</h1>\n" + SenderEmailPassword.body;
    String role = event.role;
    try {
      yield InviteEmailProcessing();
      InviteEmail checkInviteEmail =
          await _inviteEmailRepository.getInviteEmail(weddingId, to);

      UserWedding userWedding =
          await _userWeddingRepository.getUserWeddingByEmail(to);

      bool valid =
          Validation.isEmailValid(event.email) && (checkInviteEmail == null);

      if (!valid) {
        if (!Validation.isEmailValid(event.email)) {
          yield InviteEmailError(message: MessageConst.invalidEmail);
        } else if (checkInviteEmail != null) {
          yield InviteEmailError(message: MessageConst.emailAlreadyInvited);
        }
      } else {
        InviteEmail inviteEmail = new InviteEmail(
            from: from,
            date: DateTime.now(),
            to: to,
            code: code,
            weddingId: weddingId,
            title: title,
            body: body,
            role: role);
        if (userWedding != null) {
          // người dùng đã có tài khoản
          if (userWedding.weddingId == weddingId) {
            // đã có ở trong đám cưới
            yield InviteEmailError(
                message: MessageConst.userAlreadyInWeddingError);
          } else {
            // chưa có đám cưới
            await _sendEmail(inviteEmail);
            await _inviteEmailRepository.createInviteEmail(inviteEmail);

            yield InviteEmailSuccess(message: MessageConst.commonSuccess);
          }
        } else {
          // người dùng chưa có tài khoản
          await _sendEmail(inviteEmail);
          await _inviteEmailRepository.createInviteEmail(inviteEmail);

          yield InviteEmailSuccess(message: MessageConst.commonSuccess);
        }
      }
    } catch (e) {
      print("[ERROR]" + e);
      yield InviteEmailError(message: MessageConst.commonError);
    }
  }

  Future<void> _sendEmail(InviteEmail inviteEmail) async {
    String username = SenderEmailPassword.email;
    String password = SenderEmailPassword.password;

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, SenderEmailPassword.appName)
      ..recipients.add(inviteEmail.to)
      ..subject = inviteEmail.title
      ..text = SenderEmailPassword.text
      ..html = inviteEmail.body;
    //final sendReport = await send(message, smtpServer);
    //print('Message sent: ' + sendReport.toString());
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // close the connection
    await connection.close();
  }

  Stream<InviteEmailState> _mapSubmittedCodeToState(
      SubmittedCode event) async* {
    yield InviteEmailProcessing();
    try {
      final User user = await _userRepository.getUser();
      InviteEmail inviteEmail =
          await _inviteEmailRepository.getInviteEmailByCode(event.code);
      if (inviteEmail != null) {
        if (inviteEmail.to == user.email) {
          UserWedding userWedding = await _userWeddingRepository
              .getUserWeddingByEmail(inviteEmail.to);
          UserWedding newUserWedding = new UserWedding(inviteEmail.to,
              userId: user.uid,
              joinDate: DateTime.now(),
              role: inviteEmail.role,
              weddingId: inviteEmail.weddingId,
              id: userWedding.id);
          await _userWeddingRepository.updateUserWedding(newUserWedding);
          await _inviteEmailRepository.deleteInviteEmailByEmail(
              inviteEmail.to, inviteEmail.weddingId);
          yield InviteEmailSuccess(message: MessageConst.commonSuccess);
        } else {
          yield InviteEmailError(message: MessageConst.codeNotFound);
        }
      } else {
        yield InviteEmailError(message: MessageConst.codeNotFound);
      }
    } catch (e) {
      print("[ERROR]: " + e.toString());
      yield InviteEmailError(message: MessageConst.commonError);
    }
  }
}
