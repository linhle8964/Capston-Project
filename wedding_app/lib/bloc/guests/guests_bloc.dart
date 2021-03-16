import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/repository/guests_repository.dart';

class GuestsBloc extends Bloc<GuestsEvent, GuestsState> {
  final GuestsRepository _guestsRepository;
  StreamSubscription _guestsSubscription;

  GuestsBloc({GuestsRepository guestsRepository})
      : assert(guestsRepository != null),
        _guestsRepository = guestsRepository,
        super(GuestsLoading());

  @override
  Stream<GuestsState> mapEventToState(GuestsEvent event) async* {
    if(event is LoadGuests){
      yield* _mapLoadGuestsToState(event);
    }else if(event is AddGuest){
      yield* _mapAddGuestToState(event);
    }else if(event is UpdateGuest){
      yield* _mapUpdateGuestToState(event);
    }else if(event is DeleteGuest){
      yield* _mapDeleteGuestToState(event);
    }else if(event is ToggleAll){
      yield* _mapToggleAllToState(event);
    }else if(event is ClearCompleted){
      yield* _mapClearCompletedToState();
    }else if (event is SearchGuests) {
      yield* _mapSearchingToState();
    }
  }

  Stream<GuestsState> _mapLoadGuestsToState(LoadGuests event) async*{
    _guestsSubscription?.cancel();
    _guestsSubscription = _guestsRepository.readGuest(event.weddingId).listen(
            (guests) => add(ToggleAll(guests)),
    );
  }

  Stream<GuestsState> _mapAddGuestToState(AddGuest event) async*{
    _guestsRepository.createGuest(event.guest, event.weddingId);
    yield GuestAdded();
  }

  Stream<GuestsState> _mapUpdateGuestToState(UpdateGuest event) async*{
    _guestsRepository.updateGuest(event.guest, event.weddingId);
    yield GuestUpdated();
  }

  Stream<GuestsState> _mapDeleteGuestToState(DeleteGuest event) async*{
    _guestsRepository.deleteGuest(event.guest, event.weddingId);
    yield GuestDeleted();
  }

  Stream<GuestsState> _mapToggleAllToState(ToggleAll event) async*{
    yield GuestsLoaded(event.guests);
  }

  Stream<GuestsState> _mapClearCompletedToState() async*{}

  Stream<GuestsState> _mapSearchingToState() async* {
    yield GuestsSearching();
  }

  @override
  Future<void> close() {
    _guestsSubscription?.cancel();
    return super.close();
  }
}