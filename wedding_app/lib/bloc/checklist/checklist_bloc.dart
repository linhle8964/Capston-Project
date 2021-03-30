import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/repository/notification_repository.dart';
import 'package:wedding_app/repository/task_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding_app/widgets/receive_notification.dart';

class ChecklistBloc extends Bloc<TasksEvent, TaskState> {
  final TaskRepository _taskRepository;
  final NotificationRepository _notiRepository;
  StreamSubscription _taskSubscription;
  StreamSubscription _notiSubscription;

  ChecklistBloc({@required TaskRepository taskRepository,
    @required NotificationRepository notificationRepository})
      : assert(taskRepository != null && notificationRepository !=null),
        _taskRepository = taskRepository,
        _notiRepository = notificationRepository,
        super(TasksLoading());

  NotificationModel fromTask(Task task,String weddingID, List<NotificationModel> notifications){
    int number =1;
    bool isUpdating = false;
    for(int i=0; i<notifications.length; i++){
      if(task.id == notifications[i].detailsID){
        number = notifications[i].number;
        isUpdating =true;
        break;
      }
      if(notifications[i].number >= number)
        number = notifications[i].number;
    }
    NotificationModel notificationModel = new NotificationModel(
        content: "Công việc ${task.name} đã đến hạn",
        read: true,
        type: task.status ?0 :1,
        date: task.dueDate,
        detailsID: task.id,
        isNew: true,
        number: isUpdating ? number : (number +1));

    return notificationModel;
  }

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
    } else if (event is ChangeToNotification) {
      yield* _mapAddNotificationToState(event);
    }
  }

  Stream<TaskState> _mapTasksLoadedSuccessToState(LoadSuccess event) async* {
    _taskSubscription?.cancel();
    _notiSubscription?.cancel();
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
    event.task.id = myId;
    _taskRepository.addNewTask(event.task, event.weddingID);
    _notiSubscription?.cancel();
    _notiSubscription = _notiRepository.getNotifications(event.weddingID).listen(
          (notifications) => add(ChangeToNotification(event.task, notifications, event.weddingID,"adding")),
    );
  }

  Stream<TaskState> _mapAddNotificationToState(ChangeToNotification event) async* {
    if(event.status == "adding") {
      NotificationModel noti = fromTask(
          event.task, event.weddingID, event.notifications);
      _notiRepository.addNewNotication(noti, event.weddingID);
      yield TaskAdded();
    }else if(event.status == "updating1"){
      NotificationModel noti = fromTask(event.task, event.weddingID, event.notifications);
      if(noti.date.isAfter(DateTime.now()))
        _notiRepository.updateNotificationByTaskID(noti, event.weddingID);
      yield TaskUpdated();
    }else if(event.status == "updating2"){
      NotificationModel noti = fromTask(event.task, event.weddingID, event.notifications);
      if(noti.date.isAfter(DateTime.now()))
        _notiRepository.updateNotificationByTaskID(noti, event.weddingID);
      yield TaskUpdated2();
    }else if(event.status == "deleting"){
      NotificationModel noti = fromTask(event.task, event.weddingID, event.notifications);
      NotificationManagement.deleteNotification(noti.number);
      _notiRepository.deleteNotificationByTaskID(noti, event.weddingID);
      yield TaskDeleted();
    }
  }

  Stream<TaskState> _mapTaskUpdatedToState(UpdateTask event) async* {
    _taskRepository.updateTask(event.task, event.weddingID);
    _notiSubscription?.cancel();
    _notiSubscription = _notiRepository.getNotifications(event.weddingID).listen(
          (notifications) => add(ChangeToNotification(event.task, notifications, event.weddingID,"updating1")),
    );
  }

  Stream<TaskState> _mapTaskUpdated2ToState(Update2Task event) async* {
    _taskRepository.updateTask(event.task, event.weddingID);
    _notiSubscription?.cancel();
    _notiSubscription = _notiRepository.getNotifications(event.weddingID).listen(
          (notifications) => add(ChangeToNotification(event.task, notifications, event.weddingID,"updating2")),
    );
  }

  Stream<TaskState> _mapTaskDeletedToState(DeleteTask event) async* {
    _taskRepository.deleteTask(event.task, event.weddingID);
    _notiSubscription?.cancel();
    _notiSubscription = _notiRepository.getNotifications(event.weddingID).listen(
          (notifications) => add(ChangeToNotification(event.task, notifications, event.weddingID,"deleting")),
    );
  }

  Stream<TaskState> _mapSearchingToState() async* {
    yield TasksSearching();
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    _notiSubscription?.cancel();
    return super.close();
  }
}
