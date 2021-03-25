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
  static List<NotificationModel> notificationTime =[];
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

  static void addNotification(NotificationModel noti) async {
    NotificationManagement();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
   notificationTime.add(noti);
    //mapKey++;
    if (noti.date.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule(noti.id, 'Thông báo', noti.content,
          noti.date, platformChannelSpecifics);
    }
  }

  static void updateNotification(NotificationModel old, NotificationModel newNoti) async {
    deleteNotification(old);
    addNotification(newNoti);
  }



  static void ClearAllNotifications() async {
    NotificationManagement();
    notificationTime.clear();
    FlutterAppBadger.removeBadge();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static void deleteNotification(NotificationModel noti) async {
    NotificationManagement();
    notificationTime.remove(noti);
    flutterLocalNotificationsPlugin.cancel(noti.id);
  }

  /// code for alarm
  static CollectionReference reference;
  static StreamSubscription<QuerySnapshot> streamSub;
  static void  executeAlarm(String weddingID) async {
    bool res = await FlutterAppBadger.isAppBadgeSupported();
    print("Is AppBadge Supported: $res");
    if(reference == null){
      reference = FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("notification");
    }
      streamSub?.cancel();
      bool isEmpty = false;
      streamSub = reference.snapshots().listen((querySnapshot) {
        if(notificationTime.isEmpty){
          querySnapshot.docs.forEach((change) {
            notificationTime.add(NotificationModel.fromEntity(NotificationEntity.fromSnapshot(change)));
          });
        }

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
          if(notificationTime.length < querySnapshot.docs.length){
            querySnapshot.docs.forEach((change) {
              NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(change));
              if(!notificationTime.contains(noti)){
                addNotification(noti);
              }
            });
          }else if(notificationTime.length == querySnapshot.docs.length){
            querySnapshot.docs.forEach((change) {
              NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(change));
              for(int i = 0; i<notificationTime.length;i++){
                if(notificationTime[i].docID == noti.docID
                    && notificationTime[i]!= noti){
                  updateNotification(notificationTime[i], noti);
                }
              }
            });
          }else{
            for(int i=0; i< notificationTime.length; i++){
              bool isDeletedItem = true;
              NotificationModel deleted = notificationTime[i];
              querySnapshot.docs.forEach((element) {
                NotificationModel noti = NotificationModel.fromEntity(NotificationEntity.fromSnapshot(element));
                if(deleted==noti){
                  isDeletedItem = false;
                }
              });
              if(isDeletedItem == true){
                deleteNotification(deleted);
              }
            }
          }
      });
  }

  static void cancelAlarm()  {
     streamSub?.cancel();
  }
}
