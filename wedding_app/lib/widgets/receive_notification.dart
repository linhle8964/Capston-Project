import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/notification_entity.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class NotificationManagement {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //Nang

  NotificationManagement() {
    WidgetsFlutterBinding.ensureInitialized();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void addNotification(NotificationModel notificationModel) async {
    NotificationManagement();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    if (notificationModel.type != 0 && notificationModel.date.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule(notificationModel.number, 'Thông báo', notificationModel.content,
          notificationModel.date, platformChannelSpecifics);
      print("zzz");
    }
  }

  static void ClearAllNotifications() async {
    NotificationManagement();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static void deleteNotification(int key) async {
    NotificationManagement();
    flutterLocalNotificationsPlugin.cancel(key);
  }
  /// code for alarm
  static CollectionReference reference;
  static StreamSubscription<QuerySnapshot> streamSub;
  static void  executeAlarm(String weddingID) async {
    if(reference == null){
      reference = FirebaseFirestore.instance.collection('wedding')
          .doc(weddingID).collection("notification");
    }

    streamSub?.cancel();
    streamSub = reference.snapshots().listen((querySnapshot) {
      // add app badger
      int numberBadger=0;
      querySnapshot.docs.forEach((element) {
        NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(element));
        if(noti.isNew) numberBadger++;
      });
      if(numberBadger != 0){
        FlutterAppBadger.updateBadgeCount(numberBadger);
      }else{
        FlutterAppBadger.removeBadge();
      }
      //set each states (add/ update/delete)
      querySnapshot.docs.forEach((element) {
        NotificationModel notificationModel = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(element));
        addNotification(notificationModel);
      });
    });
  }

  static void cancelAlarm()  {
    streamSub?.cancel();
  }
}
