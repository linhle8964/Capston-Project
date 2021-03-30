import 'package:wedding_app/model/invite_email.dart';

abstract class InviteEmailRepository {
  Future<void> createInviteEmail(InviteEmail inviteEmail);
  Future<InviteEmail> getInviteEmail(String weddingId, String to);
  Future<InviteEmail> getInviteEmailByCode(String code);
  Future<void> deleteInviteEmailByEmail(String email, String weddingId);
  Future<void> deleteInviteEmailByWedding(String weddingId);
}
