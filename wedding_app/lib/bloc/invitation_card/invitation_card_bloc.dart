import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/bloc/invitation_card/bloc.dart';
import 'package:wedding_app/bloc/invitation_card/invitation_card_event.dart';
import 'package:wedding_app/bloc/invitation_card/invitation_card_state.dart';
import 'package:wedding_app/repository/invitation_card_repository.dart';

class InvitationCardBloc extends Bloc<InvitationCardEvent, InvitationCardState> {
  final InvitationCardRepository _invitationCardRepository;
  StreamSubscription _invitationCardSubscription;

  InvitationCardBloc({@required InvitationCardRepository invitationCardRepository})
      : assert(InvitationCardRepository != null),
        _invitationCardRepository = invitationCardRepository,
        super(InvitationCardLoading());

  @override
  Stream<InvitationCardState> mapEventToState(InvitationCardEvent event) async*{
    if(event is LoadSuccess){
      yield* _mapLoadSuccessToState(event);
    }else if(event is AddInvitationCard){
      yield* _mapInvitationCardAddedToState(event);
    }else if(event is ToggleAll){
      yield* _mapToggleAllToState(event);
    }
  }
  Stream<InvitationCardState> _mapLoadSuccessToState(LoadSuccess event) async*{
    _invitationCardSubscription?.cancel();
    _invitationCardSubscription = _invitationCardRepository.GetAllInvitationCard(event.weddingId).listen(
          (invitations) => add(InvitationCardUpdated(invitations)),
    );
  }
  Stream<InvitationCardState> _mapInvitationCardAddedToState(AddInvitationCard event) async*{
    _invitationCardRepository.addNewInvitationCard(event.invitationCard, event.weddingId);
    yield InvitationCardAdded();
  }
  Stream<InvitationCardState> _mapToggleAllToState(ToggleAll event) async*{
    yield InvitationCardLoaded();
  }
  @override
  Future<void> close() {
    _invitationCardSubscription?.cancel();
    return super.close();
  }
}