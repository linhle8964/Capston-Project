import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/task_model.dart';

@immutable
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class TasksLoadedSuccess extends TasksEvent{}

class TaskAdded extends TasksEvent {
  final Task task;

  const TaskAdded(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskAdded{task: $task}';
  }
}

class TaskUpdated extends TasksEvent {
  final Task task;

  const TaskUpdated(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskUpdated{task: $task}';
  }
}

class TaskDeleted extends TasksEvent {
  final Task task;

  const TaskDeleted(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskDeleted{task: $task}';
  }
}

class ClearCompleted extends TasksEvent {}

class ToggleAll extends TasksEvent {}

