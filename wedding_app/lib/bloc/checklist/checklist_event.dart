import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/task_model.dart';

@immutable
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class LoadSuccess extends TasksEvent{}

class AddTask extends TasksEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskAdded{task: $task}';
  }
}

class UpdateTask extends TasksEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskUpdated{task: $task}';
  }
}

class Update2Task extends TasksEvent {
  final Task task;

  const Update2Task(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskUpdated{task: $task}';
  }
}

class DeleteTask extends TasksEvent {
  final Task task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() {
    return 'TaskDeleted{task: $task}';
  }
}

class ToggleAll extends TasksEvent {
  final List<Task> tasks;

  const ToggleAll(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class DuedateCome extends TasksEvent {
  final DateTime dueDate;

  const DuedateCome(this.dueDate);
}
