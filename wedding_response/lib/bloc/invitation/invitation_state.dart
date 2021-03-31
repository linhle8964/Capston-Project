

import 'package:flutter/cupertino.dart';
import 'package:flutter_web_diary/model/invitation.dart';

@immutable
abstract class InvitationState {}

class InvitationCardLoading extends InvitationState {}

class InvitationCardLoaded extends InvitationState {
  InvitationCard invitationCard;
  InvitationCardLoaded( this.invitationCard);
}
