import 'package:wedding_app/model/invite_email.dart';

abstract class InviteEmailRepository {
  Future<void> createInviteEmail(InviteEmail inviteEmail);
}
