/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/notification_entity.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'package:wedding_app/widgets/receive_notification.dart';


class AddTaskNotification {
  static List<Task> tasks =[];
  static NotificationRepository notificationRepository;

  /// code for alarm
  static CollectionReference reference;
  static CollectionReference referenceNotification;
  static StreamSubscription<QuerySnapshot> streamSub;

  static void  addTaskNotification(String weddingID) async {
    notificationRepository = new NotificationFirebaseRepository();
    if(reference == null){
      reference = FirebaseFirestore.instance.collection('wedding')
          .doc(weddingID).collection("task");
    }
    if(referenceNotification == null){
      referenceNotification = FirebaseFirestore.instance.collection('wedding')
          .doc(weddingID).collection("notification");
    }
    streamSub?.cancel();
    streamSub = reference.snapshots().listen((querySnapshot) {
      if(tasks.isEmpty){
        querySnapshot.docs.forEach((change) {
          tasks.add(Task.fromEntity(TaskEntity.fromSnapshot(change)));
        });
      }
      //set each states (add/ update/delete)
      if(tasks.length < querySnapshot.docs.length ){
        querySnapshot.docs.forEach((change) {
          Task task = Task.fromEntity(TaskEntity.fromSnapshot(change));
          if(!tasks.contains(task)){
            NotificationModel notification = NotificationModel.fromTask(task,
                  NotificationManagement.notificationTime, weddingID);
            tasks.add(task);
            notificationRepository.addNewNotication(notification, weddingID);
          }
        });
      }else if(tasks.length == querySnapshot.docs.length){
        querySnapshot.docs.forEach((change) {
          Task task = Task.fromEntity(TaskEntity.fromSnapshot(change));
          for(int i = 0; i<tasks.length;i++){
            //updating
            if(tasks[i].id == task.id
                && tasks[i]!= task){
              NotificationModel notification = NotificationModel.fromTask(task,
                  NotificationManagement.notificationTime, weddingID);
              tasks[i] = task;
              bool isUpdating = false;
              for(int i=0; i< NotificationManagement.notificationTime.length;i++){
                if(task.id == NotificationManagement.notificationTime[i].detailsID) {
                  isUpdating = true;
                  break;
                }
              }
              if(isUpdating)
                notificationRepository.updateNotificationByTaskID(notification, weddingID);
              else notificationRepository.addNewNotication(notification, weddingID);
            }
          }
        });
      }else{
        for(int i=0; i< tasks.length; i++){
          bool isDeletedItem = true;
          Task deleted = tasks[i];
          querySnapshot.docs.forEach((element) {
            Task task = Task.fromEntity(TaskEntity.fromSnapshot(element));
            if(deleted==task){
              isDeletedItem = false;
            }
          });
          if(isDeletedItem == true){
            //deleteing
            NotificationModel notification = NotificationModel.fromTask(deleted,
                NotificationManagement.notificationTime, weddingID);
            tasks.remove(deleted);
            notificationRepository.deleteNotificationByTaskID(notification, weddingID);

          }
        }
      }
    });
  }

  static void cancel()  {
    streamSub?.cancel();
  }
}
*/
