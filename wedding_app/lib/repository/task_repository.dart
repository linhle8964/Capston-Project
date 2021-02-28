import 'dart:async';
import 'package:wedding_app/model/task_model.dart';

abstract class TaskRepository {
  Future<void> addNewTask(Task task);

  Future<void> deleteTask(Task task);

  Stream<List<Task>> getTasks(String weddingId);

  Future<void> updateTask(Task task);
}