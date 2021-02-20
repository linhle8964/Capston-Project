import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/task_repository.dart';

class ChecklistBloc extends Bloc<TasksEvent, TaskState> {
  final TaskRepository _taskRepository;
  StreamSubscription _taskSubscription;

  ChecklistBloc({@required TaskRepository taskRepository}) : assert(taskRepository != null),
        _taskRepository = taskRepository,
        super(TasksLoadInProgress());

  @override
  Stream<TaskState> mapEventToState(
    TasksEvent event,
  ) async* {
    if(event is TasksLoadedSuccess){
      yield* _mapTasksLoadedSuccessToState();
    }else if(event is TaskAdded){
      yield* _mapTaskAddedToState(event);
    }else if(event is TaskUpdated){
      yield* _mapTaskUpdatedToState(event);
    }else if(event is TaskDeleted){
      yield* _mapTaskDeletedToState(event);
    }else if(event is ClearCompleted){
      yield* _mapClearCompletedToState();
    }else if(event is ToggleAll){
      yield* _mapToggleAllToState();
    }
  }

  Stream<TaskState> _mapTasksLoadedSuccessToState() async* {

  }

  Stream<TaskState> _mapTaskAddedToState(TaskAdded event) async* {

  }

  Stream<TaskState> _mapTaskUpdatedToState(TaskUpdated event) async* {

  }

  Stream<TaskState> _mapTaskDeletedToState(TaskDeleted event) async* {

  }

  Stream<TaskState> _mapToggleAllToState() async* {

  }

  Stream<TaskState> _mapClearCompletedToState() async* {

  }

  Future _saveTasks(List<Task> tasks) {
    return null;
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
