import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationBloc() : super(InvitationInitial());

  @override
  Stream<InvitationState> mapEventToState(
    InvitationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
