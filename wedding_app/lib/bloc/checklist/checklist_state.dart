
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/task_model.dart';

@immutable
abstract class TaskState extends Equatable {
  TaskState();

  @override
  List<Object> get props => [];
}

class TasksLoadInProgress extends TaskState {}
class TasksLoadSuccess extends TaskState {
  final List<Task> tasks;

  TasksLoadSuccess([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() {
    return 'TasksLoadSuccess{tasks: $tasks}';
  }
}
class TasksLoadFailure extends TaskState {}
