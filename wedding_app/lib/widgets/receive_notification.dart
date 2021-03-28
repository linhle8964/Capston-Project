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
  static Map<int, NotificationModel> notificationTime ={};
  static int mapKey = 1;

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
    notificationTime.addAll({mapKey: notificationModel});
    mapKey++;
    if (notificationModel.date.isAfter(DateTime.now().subtract(Duration(minutes: 3)))) {
      await flutterLocalNotificationsPlugin.schedule((mapKey-1), 'Thông báo', notificationModel.content,
          notificationModel.date, platformChannelSpecifics);
    }
  }

  static void updateNotification(NotificationModel old, NotificationModel newNoti) async {
    int key=-1;
    for(int i=0; i<notificationTime.length; i++){
      if(old == notificationTime.values.elementAt(i)){
        key = notificationTime.keys.elementAt(i);
        break;
      }
    }
    if(key==-1){
      key= mapKey++;
    }
    deleteNotification(key);
    addNotification(newNoti);
  }



  static void ClearAllNotifications() async {
    NotificationManagement();
    notificationTime.clear();
    mapKey=1;
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static void deleteNotification(int key) async {
    NotificationManagement();
    notificationTime.remove(key);
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
      if(notificationTime.isEmpty){
        querySnapshot.docs.forEach((change) {
          addNotification(NotificationModel.fromEntity(NotificationEntity.fromSnapshot(change)));
        });
      }else{
        if(notificationTime.length < querySnapshot.docs.length){
          querySnapshot.docs.forEach((change) {
            NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(change));
            if(!notificationTime.containsValue(noti)){
              addNotification(noti);
            }
          });
        }else if(notificationTime.length == querySnapshot.docs.length){
          querySnapshot.docs.forEach((change) {
            NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(change));
            for(int i = 0; i<notificationTime.length;i++){
              if(notificationTime.values.elementAt(i).docID == noti.docID
                  && notificationTime.values.elementAt(i)!= noti){
                updateNotification(notificationTime.values.elementAt(i), noti);
              }
            }
          });
        }else{
          for(int i=0; i< notificationTime.length; i++){
            bool isDeletedItem = true;
            NotificationModel deleted = notificationTime.values.elementAt(i);
            querySnapshot.docs.forEach((element) {
              NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(element));
              if(deleted==noti){
                isDeletedItem = false;
              }
            });
            if(isDeletedItem == true){
              int key = notificationTime.keys.elementAt(i);
              deleteNotification(key);
            }
          }
        }
      }
    });
  }

  static void cancelAlarm()  {
    streamSub?.cancel();
  }
}
