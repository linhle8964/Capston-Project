import 'package:wedding_app/model/notification.dart';

abstract class NotificationState {}

class NotificationsLoading extends NotificationState {}

class NotificationDeleted extends NotificationState {}

class NotificationUpdated extends NotificationState {}

class NotificationCreated extends NotificationState {}

class NewNotificationsUpdated extends NotificationState {}

class AllNotificationsDeleted extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationsLoaded(this.notifications);
}