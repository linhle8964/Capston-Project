import 'package:equatable/equatable.dart';
import 'package:wedding_app/model/invitation_card.dart';

abstract class InvitationCardState extends Equatable{
  const InvitationCardState();

  @override
  List<Object> get props => [];
}

class InvitationCardLoading extends InvitationCardState{}

class InvitationCardLoaded extends InvitationCardState{
  final List<InvitationCard> invitations;

  const InvitationCardLoaded([this.invitations= const[]]);

  @override
  List<Object> get props =>[invitations];

  @override
  String toString() => 'TemplateCardLoaded {templateCard: $invitations}';


}
class InvitationCardNotLoaded extends InvitationCardState{}

class InvitationCardAdded extends InvitationCardState{}