import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationManagement {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //Nang
  static Map<int, Task> notificationTime ={};
  static int mapKey = 1;
  static bool isNotificationAllowed = false;

  NotificationManagement() {
    WidgetsFlutterBinding.ensureInitialized();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void addNotification(Task task) async {
    NotificationManagement();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    notificationTime.addAll({mapKey: task});
    mapKey++;
    print("ADD ${notificationTime.toString()}");
    if (task.dueDate.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule((mapKey-1), 'Đã đến hạn công việc', task.name,
          task.dueDate, platformChannelSpecifics);
    }
  }


  static void ClearAllNotifications() async {
    NotificationManagement();
    notificationTime.clear();
    print("CLEAR: ${notificationTime.toString()}");
    mapKey=1;
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static CollectionReference reference;
  static StreamSubscription<QuerySnapshot> streamSub;
  static void  executeAlarm(String weddingID) async {
    if(reference == null){
      reference = FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("task");
    }
      streamSub?.cancel();
      streamSub = reference.snapshots().listen((querySnapshot) {
          NotificationManagement.ClearAllNotifications();
          querySnapshot.docs.forEach((change) {
            // Do something with change
            Task task = Task.fromEntity(TaskEntity.fromSnapshot(change));
            NotificationManagement.addNotification(task);
          });
      });
  }

  static void cancelAlarm()  {
     streamSub?.cancel();
  }
}
