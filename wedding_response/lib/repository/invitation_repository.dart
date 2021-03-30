import 'package:flutter_web_diary/model/invitation.dart';

abstract class InvitationCardRepository {
  Future<InvitationCard> getInvitationCardById(String weddingId);
}
