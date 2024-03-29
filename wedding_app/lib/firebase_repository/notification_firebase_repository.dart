import 'package:wedding_app/entity/notification_entity.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationFirebaseRepository implements NotificationRepository {
  @override
  Future<void> addNewNotication(
      NotificationModel notification, String weddingID) {
    return FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .add(notification.toEntity().toDocument());
  }

  @override
  Future<void> deleteAllNotifications(
      String weddingID, List<NotificationModel> notifications) {
    for (int i = 0; i < notifications.length; i++) {
      deleteNotification(notifications[i], weddingID);
    }
  }

  @override
  Future<void> deleteNotification(
      NotificationModel notification, String weddingID) {
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
        //.where("date", isLessThan: DateTime.now()) // công việc đã hoàn thành không thông báo
        .orderBy("date", descending: true)
        //.where("type", isGreaterThan: 0)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromEntity(
              NotificationEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateNotification(
      NotificationModel notification, String weddingID) {
    return FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .doc(notification.docID)
        .update(notification.toEntity().toDocument());
  }

  @override
  Future<void> updateNewNotifications(
      String weddingID, List<NotificationModel> notifications) {
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].isNew) {
        notifications[i].isNew = false;
        updateNotification(notifications[i], weddingID);
      }
    }
  }

  @override
  Future<void> updateNotificationByTaskID(
      NotificationModel notification, String weddingID) {
    var query = FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .where("details_id", isEqualTo: notification.detailsID)
        .get();

    return query.then((snapshots) {
      if (snapshots.size == 0) addNewNotication(notification, weddingID);
      for (DocumentSnapshot snapshot in snapshots.docs) {
        notification.docID = snapshot.id;
        snapshot.reference.update(notification.toEntity().toDocument());
      }
    });
  }

  @override
  Future<void> deleteNotificationByTaskID(
      NotificationModel notificationModel, String weddingID) {
    return FirebaseFirestore.instance
        .collection('wedding')
        .doc(weddingID)
        .collection("notification")
        .where("details_id", isEqualTo: notificationModel.detailsID)
        .get()
        .then((snapshots) {
      for (DocumentSnapshot snapshot in snapshots.docs) {
        snapshot.reference.delete();
      }
    });
  }
}
