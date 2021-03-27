import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  StreamSubscription _notificationSubscription;

  NotificationBloc({@required NotificationRepository notificationRepository})
      : assert(notificationRepository != null),
        _notificationRepository = notificationRepository,
        super(NotificationsLoading());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState(event);
    }else if (event is DeleteNotification) {
      yield* _mapDeleteNotificationToState(event);
    } else if (event is DeleteAllNotifications) {
      yield* _mapDeleteAllNotificationsToState(event);
    }else if (event is UpdateNotification) {
      yield* _mapUpdateNotificationToState(event);
    }else if (event is UpdateNewNotifications) {
      yield* _mapUpdateNewNotificationsToState(event);
    }else if (event is CreateNotification) {
      yield* _mapCreateNotificationToState(event);
    }
  }

  Stream<NotificationState> _mapLoadNotificationsToState(LoadNotifications event) async* {
    _notificationSubscription?.cancel();
    _notificationSubscription = _notificationRepository.getNotifications(event.weddingID).listen(
          (notifications) => add(ToggleAll(notifications)),
    );
  }

  Stream<NotificationState> _mapToggleAllToState(ToggleAll event) async* {
    yield NotificationsLoaded(event.notifications);
  }

  Stream<NotificationState> _mapDeleteNotificationToState(DeleteNotification event) async* {
    _notificationRepository.deleteNotification(event.notification, event.weddingID);
    yield NotificationDeleted();
  }

  Stream<NotificationState> _mapDeleteAllNotificationsToState(DeleteAllNotifications event) async* {
    _notificationRepository.deleteAllNotifications(event.weddingID, event.notifications);
    yield AllNotificationsDeleted();
  }

  Stream<NotificationState> _mapUpdateNotificationToState(UpdateNotification event) async* {
    _notificationRepository.updateNotification( event.notification,event.weddingID,);
    yield NotificationUpdated();
  }

  Stream<NotificationState> _mapUpdateNewNotificationsToState(UpdateNewNotifications event) async* {
    _notificationRepository.updateNewNotifications(event.weddingID, event.notifications);
    yield NewNotificationsUpdated();
  }

  Stream<NotificationState> _mapCreateNotificationToState(CreateNotification event) async* {
    _notificationRepository.addNewNotication(event.notification, event.weddingID);
    yield NotificationCreated();
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
