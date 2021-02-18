import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/model/invite_email.dart';
import 'package:wedding_app/model/user_wedding.dart';
import 'package:wedding_app/repository/invite_email_repository.dart';
import 'package:wedding_app/repository/user_wedding_repository.dart';
import 'package:wedding_app/utils/random_string.dart';
import 'package:wedding_app/utils/validations.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class InviteEmailBloc extends Bloc<InviteEmailEvent, InviteEmailState> {
  final InviteEmailRepository _inviteEmailRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserWeddingRepository _userWeddingRepository;

  InviteEmailBloc(
      {@required InviteEmailRepository inviteEmailRepository,
      @required UserWeddingRepository userWeddingRepository})
      : assert(inviteEmailRepository != null),
        assert(userWeddingRepository != null),
        _inviteEmailRepository = inviteEmailRepository,
        _userWeddingRepository = userWeddingRepository,
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
    String to = event.email;
    String title = "Bạn nhận được lời mời tham dự chỉnh sửa đám cưới";
    String body =
        "<h1>$code</h1>\n<p>Tải app và nhập code trên để tham dự chỉnh sửa đám cưới. Nếu không phải là bạn xin hãy bỏ qua mail này</p> ";
    String role = event.role;
    try {
      yield InviteEmailProcessing();
      InviteEmail checkInviteEmail =
          await _inviteEmailRepository.getInviteEmail(weddingId, to);

      UserWedding userWedding =
          await _userWeddingRepository.getUserWeddingByEmail(to);
      if (!Validation.isEmailValid(event.email)) {
        yield InviteEmailError(message: "Email không đúng");
      } else if (checkInviteEmail != null) {
        yield InviteEmailError(message: "Email này đã được mời");
      } else if (userWedding.weddingId == weddingId) {
        yield InviteEmailError(message: "Người dùng này đã có trong đám cưới");
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
    String username = 'linhlche130970@fpt.edu.vn';
    String password = 'Linh4698,';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Lê Linh')
      ..recipients.add(inviteEmail.to)
      ..subject = inviteEmail.title
      ..text = "Xin chào\nVWED xin kính chào"
      ..html = inviteEmail.body;
    //final sendReport = await send(message, smtpServer);
    //print('Message sent: ' + sendReport.toString());
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // close the connection
    await connection.close();
  }
}
