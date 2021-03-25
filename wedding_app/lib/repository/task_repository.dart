import 'dart:async';
import 'package:wedding_app/model/task_model.dart';

abstract class TaskRepository {
  Future<void> addNewTask(Task task,String weddingID);

  Future<void> deleteTask(Task task,String weddingID);

  Stream<List<Task>> getTasks(String weddingID);

  Future<void> updateTask(Task task,String weddingID);

}