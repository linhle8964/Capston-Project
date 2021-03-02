import 'package:wedding_app/model/Invitation_card.dart';
import 'dart:async';
abstract class InvitationCardRepository {
  Stream<List<InvitationCard>> GetAllInvitationCard(String weddingID);

  Future<void> addNewInvitationCard(InvitationCard invitationCard,
      String weddingID);
}
