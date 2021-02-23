import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/entity/task_entity.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/task_repository.dart';
import 'package:wedding_app/utils/get_data.dart';

class FirebaseTaskRepository implements TaskRepository{

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
  Stream<List<Task>> getTasks() {
    return taskCollection.snapshots().map((snapshot) {
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