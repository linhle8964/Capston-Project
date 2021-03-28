import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/model/Invitation_card.dart';

@immutable
abstract class InvitationCardEvent extends Equatable {
  const InvitationCardEvent();

  @override
  List<Object> get props => [];
}

class LoadSuccess extends InvitationCardEvent{
  String weddingId;
  LoadSuccess(this.weddingId);
}

class AddInvitationCard extends InvitationCardEvent{
  final InvitationCard invitationCard;
  String weddingId;
  AddInvitationCard(this.invitationCard,this.weddingId);

  @override
  List<Object> get props => [invitationCard];

  @override
  String toString() {
    return 'InvitationCardAdded:{$invitationCard}';
  }

}

class ClearCompleted extends InvitationCardEvent{}

class ToggleAll extends InvitationCardEvent{}

class InvitationCardUpdated extends InvitationCardEvent{
  final List<InvitationCard> invitations;

  const InvitationCardUpdated(this.invitations);

  @override
  List<Object> get props => [invitations];


}