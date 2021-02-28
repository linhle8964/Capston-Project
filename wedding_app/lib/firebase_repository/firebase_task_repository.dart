import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/task_repository.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseTaskRepository implements TaskRepository{
  /*String weddingID;
  var  taskCollection;

  FirebaseTaskRepository(){
    getWeddingID(weddingID);
    print(weddingID);
    FirebaseFirestore.instance.collection('wedding')
        .doc(weddingID).collection("task");
  }

  Future<void> getWeddingID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("wedding_id");
  }*/

  var taskCollection = FirebaseFirestore.instance.collection('wedding')
      .doc("M5TQqVr7WrpfsdyGbwP0").collection("task");


  @override
  Future<void> addNewTask(Task task) {
    return taskCollection.add(task.toEntity().toDocument());
  }

  @override
  Future<void> deleteTask(Task task) {
    return taskCollection.doc(task.id).delete();
  }

  @override
  Stream<List<Task>> getTasks(String weddingId) {
    return FirebaseFirestore.instance.collection('wedding')
        .doc(weddingId)
        .collection("budget")
        .orderBy("due_date", descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromEntity(TaskEntity.fromSnapshot(doc)))
          .toList();

    });
  }

  @override
  Future<void> updateTask(Task task) {
    return taskCollection
        .doc(task.id)
        .update(task.toEntity().toDocument());
  }
  
}