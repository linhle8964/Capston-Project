
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/task_model.dart';

@immutable
abstract class TaskState extends Equatable {
  TaskState();

  @override
  List<Object> get props => [];
}

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  TasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() {
    return 'TasksLoaded{tasks: $tasks}';
  }
}
class TasksLoadFailure extends TaskState {}

class TaskDeleted extends TaskState {}

class TaskAdded extends TaskState {}

class TaskUpdated extends TaskState {}

class TaskUpdated2 extends TaskState {}

