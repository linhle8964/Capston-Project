import 'dart:async';

import 'package:wedding_app/model/notification.dart';

abstract class NotificationRepository {
  Future<void> addNewNotication(NotificationModel notification,String weddingID);

  Future<void> deleteNotification(NotificationModel notification,String weddingID);

  Future<void> deleteAllNotifications(String weddingID, List<NotificationModel> notifications);

  Stream<List<NotificationModel>> getNotifications(String weddingID);

  Future<void> updateNotification(NotificationModel notification,String weddingID);

  Future<void> updateNewNotifications(String weddingID, List<NotificationModel> notifications);
}