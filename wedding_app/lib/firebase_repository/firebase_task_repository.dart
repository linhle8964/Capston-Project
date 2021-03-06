import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/task_repository.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/notification.dart';

class FirebaseTaskRepository implements TaskRepository{

  FirebaseTaskRepository();
  @override
  Future<void> addNewTask(Task task,String weddingID) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("task")
        .add(task.toEntity().toDocument());
  }

  @override
  Future<void> deleteTask(Task task,String weddingID) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("task").
    doc(task.id).delete();
  }

  @override
  Stream<List<Task>> getTasks(String weddingID) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("task")
        .orderBy("due_date", descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromEntity(TaskEntity.fromSnapshot(doc)))
          .toList();

    });
  }

  @override
  Future<void> updateTask(Task task,String weddingID) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("task")
        .doc(task.id)
        .update(task.toEntity().toDocument());
  }
  
}