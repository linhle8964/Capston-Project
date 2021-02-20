import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/task_repository.dart';

class FirebaseTaskRepository implements TaskRepository{
  final taskCollection = FirebaseFirestore.instance.collection('task');

  @override
  Future<void> addNewTask(Task task) {
    // TODO: implement addNewTask
  }

  @override
  Future<void> deleteTask(Task task) {
    // TODO: implement deleteTask
  }

  @override
  Stream<List<Task>> getTasks() {
    // TODO: implement getTasks
  }

  @override
  Future<void> updateTask(Task task) {
    // TODO: implement updateTask
  }
  
}