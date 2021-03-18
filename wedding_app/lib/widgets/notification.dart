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
    if (task.dueDate.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule((mapKey-1), 'Đã đến hạn công việc', task.name,
          task.dueDate, platformChannelSpecifics);
    }
  }

  static void updateNotification(Task oldtask, Task newTask) async {
    int key=-1;
    for(int i=0; i<notificationTime.length; i++){
      if(oldtask == notificationTime.values.elementAt(i)){
        key = notificationTime.keys.elementAt(i);
        break;
      }
    }
    if(key==-1){
      key= mapKey++;
    }
    deleteNotification(key, oldtask);
    addNotification(newTask);
  }



  static void ClearAllNotifications() async {
    NotificationManagement();
    notificationTime.clear();
    mapKey=1;
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static void deleteNotification(int key,Task task) async {
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
        .doc(weddingID).collection("task");
    }
      streamSub?.cancel();
      bool isEmpty = false;
      streamSub = reference.snapshots().listen((querySnapshot) {
        if(notificationTime.isEmpty){
          querySnapshot.docs.forEach((change) {
            addNotification(Task.fromEntity(TaskEntity.fromSnapshot(change)));
          });
        }else{
          if(notificationTime.length < querySnapshot.docs.length){
            querySnapshot.docs.forEach((change) {
              Task task = Task.fromEntity(TaskEntity.fromSnapshot(change));
              if(!notificationTime.containsValue(task)){
                addNotification(task);
              }
            });
          }else if(notificationTime.length == querySnapshot.docs.length){
            querySnapshot.docs.forEach((change) {
              Task task = Task.fromEntity(TaskEntity.fromSnapshot(change));
              for(int i = 0; i<notificationTime.length;i++){
                if(notificationTime.values.elementAt(i).id == task.id
                    && notificationTime.values.elementAt(i)!= task){
                  updateNotification(notificationTime.values.elementAt(i), task);
                }
              }
            });
          }else{
            for(int i=0; i< notificationTime.length; i++){
              bool isDeletedItem = true;
              Task deleted = notificationTime.values.elementAt(i);
              querySnapshot.docs.forEach((element) {
                Task task = Task.fromEntity(TaskEntity.fromSnapshot(element));
                if(deleted==task){
                  isDeletedItem = false;
                }
              });
              if(isDeletedItem == true){
                int key = notificationTime.keys.elementAt(i);
                deleteNotification(key, deleted);
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
