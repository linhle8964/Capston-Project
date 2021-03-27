import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'package:wedding_app/repository/task_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistBloc extends Bloc<TasksEvent, TaskState> {
  final TaskRepository _taskRepository;
  final NotificationRepository _notiRepository;
  StreamSubscription _taskSubscription;

  ChecklistBloc({@required TaskRepository taskRepository,
    @required NotificationRepository notificationRepository})
      : assert(taskRepository != null && notificationRepository !=null),
        _taskRepository = taskRepository,
        _notiRepository = notificationRepository,
        super(TasksLoading());

  @override
  Stream<TaskState> mapEventToState(
    TasksEvent event,
  ) async* {
    if (event is LoadSuccess) {
      yield* _mapTasksLoadedSuccessToState(event);
    } else if (event is AddTask) {
      yield* _mapTaskAddedToState(event);
    } else if (event is UpdateTask) {
      yield* _mapTaskUpdatedToState(event);
    } else if (event is Update2Task) {
      yield* _mapTaskUpdated2ToState(event);
    } else if (event is DeleteTask) {
      yield* _mapTaskDeletedToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState(event);
    } else if (event is SearchTasks) {
      yield* _mapSearchingToState();
    }
  }

  Stream<TaskState> _mapTasksLoadedSuccessToState(LoadSuccess event) async* {
    _taskSubscription?.cancel();
    _taskSubscription = _taskRepository.getTasks(event.weddingID).listen(
          (tasks) => add(ToggleAll(tasks)),
        );
  }

  Stream<TaskState> _mapToggleAllToState(ToggleAll event) async* {
    yield TasksLoaded(event.tasks);
  }

  Stream<TaskState> _mapTaskAddedToState(AddTask event) async* {
    DocumentReference ref =  FirebaseFirestore.instance
        .collection('wedding')
        .doc(event.weddingID)
        .collection("task").doc();
    String myId = ref.id;
    NotificationModel noti = NotificationModel.fromTask(event.task, event.weddingID);
    noti.detailsID = myId;
    event.task.id = myId;
    _taskRepository.addNewTask(event.task, event.weddingID);
    _notiRepository.addNewNotication(noti, event.weddingID);
    yield TaskAdded();
  }

  Stream<TaskState> _mapTaskUpdatedToState(UpdateTask event) async* {
    _taskRepository.updateTask(event.task, event.weddingID);
    NotificationModel noti = NotificationModel.fromTask(event.task, event.weddingID);
    _notiRepository.updateNotificationByTaskID(noti, event.weddingID);
    yield TaskUpdated();
  }

  Stream<TaskState> _mapTaskUpdated2ToState(Update2Task event) async* {
    _taskRepository.updateTask(event.task, event.weddingID);
    NotificationModel noti = NotificationModel.fromTask(event.task, event.weddingID);
    _notiRepository.updateNotificationByTaskID(noti, event.weddingID);
    yield TaskUpdated2();
  }

  Stream<TaskState> _mapTaskDeletedToState(DeleteTask event) async* {
    _taskRepository.deleteTask(event.task, event.weddingID);
    NotificationModel noti = NotificationModel.fromTask(event.task, event.weddingID);
    _notiRepository.deleteNotificationByTaskID(noti, event.weddingID);
    yield TaskDeleted();
  }

  Stream<TaskState> _mapSearchingToState() async* {
    yield TasksSearching();
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
