import 'package:wedding_app/model/notification.dart';


abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  String weddingID;
  LoadNotifications( this.weddingID);
}

class ToggleAll extends NotificationEvent {
  List<NotificationModel> notifications;
  ToggleAll(this.notifications);
}

class DeleteNotification extends NotificationEvent {
  String weddingID;
  NotificationModel notification;
  DeleteNotification( this.weddingID,this.notification);
}

class DeleteAllNotifications extends NotificationEvent {
  String weddingID;
  List<NotificationModel> notifications;
  DeleteAllNotifications( this.weddingID, this.notifications);
}

class UpdateNewNotifications extends NotificationEvent {
  String weddingID;
  List<NotificationModel> notifications;
  UpdateNewNotifications( this.weddingID, this.notifications);
}

class UpdateNotification extends NotificationEvent {
  final NotificationModel notification;
  String weddingID;
  UpdateNotification(this.notification,this.weddingID);

}