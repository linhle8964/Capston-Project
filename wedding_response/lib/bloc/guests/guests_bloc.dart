import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/model/notification.dart';
import 'package:flutter_web_diary/repository/guests_repository.dart';
import 'package:flutter_web_diary/repository/notification_repository.dart';

import 'bloc.dart';


class GuestsBloc extends Bloc<GuestsEvent, GuestsState> {
  final GuestsRepository _guestsRepository;
  final NotificationRepository _notiRepository;
  StreamSubscription _guestsSubscription;

  GuestsBloc({@required GuestsRepository guestsRepository, @required NotificationRepository notificationRepository})
      : assert(guestsRepository != null && notificationRepository != null),
        _guestsRepository = guestsRepository,
        _notiRepository = notificationRepository,
        super(GuestsLoading());

  @override
  Stream<GuestsState> mapEventToState(GuestsEvent event) async* {
    if(event is LoadGuests){
      yield* _mapLoadGuestsToState(event);
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
    }else if (event is LoadGuestByID) {
      yield* _mapLoadByIDToState(event);
    }else if (event is ChooseCompanion) {
      yield* _mapChooseCompanionToState();
    }
  }

  Stream<GuestsState> _mapLoadGuestsToState(LoadGuests event) async*{
    _guestsSubscription?.cancel();
    _guestsSubscription = _guestsRepository.readGuest(event.weddingId).listen(
            (guests) => add(ToggleAll(guests)),
    );
  }

  Stream<GuestsState> _mapUpdateGuestToState(UpdateGuest event) async*{
    _guestsRepository.updateGuest(event.guest, event.weddingId);
    NotificationModel noti = NotificationModel.fromGuest(event.guest, event.weddingId);
    _notiRepository.updateNotificationByTaskID(noti, event.weddingId);
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

  Stream<GuestsState> _mapChooseCompanionToState() async* {
    yield CompanionChose();
  }

  Stream<GuestsState> _mapLoadByIDToState(LoadGuestByID event) async* {
    Guest guest = await _guestsRepository.readGuestByID(event.weddingId, event.guestID);
    yield GuestsLoadedByID(guest);
  }

  @override
  Future<void> close() {
    _guestsSubscription?.cancel();
    return super.close();
  }
}