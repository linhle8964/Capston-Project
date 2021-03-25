import 'package:flutter/material.dart';
import 'package:wedding_app/entity/notification_entity.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirebaseRepository implements NotificationRepository{

  @override
  Future<void> addNewNotication(NotificationModel notification, String weddingID) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllNotifications(String weddingID, List<NotificationModel> notifications) {
   for(int i=0; i< notifications.length;i++){
     deleteNotification(notifications[i], weddingID);
   }
  }

  @override
  Future<void> deleteNotification(NotificationModel notification, String weddingID) {
    return FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .doc(notification.docID)
        .delete();
  }

  @override
  Stream<List<NotificationModel>> getNotifications(String weddingID) {
    return FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromEntity(NotificationEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateNotification(NotificationModel notification, String weddingID) {
    return FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .doc(notification.docID)
        .update(notification.toEntity().toDocument());
  }

  @override
  Future<void> updateNewNotifications(String weddingID, List<NotificationModel> notifications) {
    for(int i=0; i< notifications.length;i++){
      if(notifications[i].isNew) {
        notifications[i].isNew =false;
        updateNotification(notifications[i], weddingID);
      }
    }
  }

}