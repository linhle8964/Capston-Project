import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/task_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); //Nang
Map<int, Task> notificationTime ={};
int mapKey = 1;

class NotificationManagement {
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
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 30));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    notificationTime.addAll({mapKey: task});
    mapKey++;
    print("addNotification................: ${notificationTime.toString()}");
    if (task.dueDate.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule(mapKey, 'Thông báo', "Đã đến hạn công việc: ${task.name}",
          task.dueDate, platformChannelSpecifics);
    }
  }

  static void addExistingNotifications(List<Task> tasks) async {
    for(int i=0; i< tasks.length;i++){
      addNotification(tasks[i]);
    }
    print("addAllNotification................: ${notificationTime.toString()}");
  }

  static void updateNotification(Task oldTask,Task newTask) async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 30));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.high, importance: Importance.max);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    int key =-1;
    for(int i=0; i< notificationTime.length; i++){
      if(notificationTime.values.elementAt(i).isEqual(oldTask)){
        key = notificationTime.keys.elementAt(i);
        break;
      }
    }
    if(key==-1){
      key= mapKey;
      mapKey++;
    }
    print("KEY: $key");
    notificationTime.addAll({key: newTask});

    print("updateNotification.............: ${notificationTime.toString()}");
    if (newTask.dueDate.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.schedule(key, 'Thông báo', "Đã đến hạn công việc: ${newTask.name}",
          newTask.dueDate, platformChannelSpecifics);
    }
  }

  static void deleteNotification(Task task) async {
    int key =-1;
    print("DELETE ${task.toString()}");
    for(int i=0; i< notificationTime.length; i++){
      print(notificationTime.values.elementAt(i).isEqual(task) ? "TTT": "FFF");
      if(notificationTime.values.elementAt(i).isEqual(task)){
        key = notificationTime.keys.elementAt(i);
        notificationTime.remove(key);
        break;
      }
    }
    print("KEY: $key");
    print("DeleteNotification..............: ${notificationTime.toString()}");
    await flutterLocalNotificationsPlugin.cancel(key);
  }

  static void ClearAllNotifications() async {
    notificationTime.clear();
    print("ClearAllNotification.............: ${notificationTime.toString()}");
    mapKey=1;
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
