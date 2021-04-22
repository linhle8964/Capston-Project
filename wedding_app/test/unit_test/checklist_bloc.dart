import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/model/task_model.dart';

void main() {

  Task mockTask = new Task(
    id: "huw6DX01BNxkcJhhqH52",
    name: "Đi thuê dạp",
    status: false,
    category: "lễ cưới",
    dueDate: DateTime.now(),
    note: "",
  );

  List<NotificationModel> notifications = [
    NotificationModel(content: "Công việc Thiết kế thiệp đã đến hạn",
        read: true, type: 1, date: DateTime.now(),
        detailsID: "wPfq4JSAYcMKLNBLaBXA", isNew: false, number: 2),
    NotificationModel(content: "A Quân đã trả lời lời mời đám cưới",
        read: true, type: 2, date: DateTime.now(),
        detailsID: "huw6DX01BNxkcJhhqH52", isNew: false, number: 3),
  ];

  group("MapTaskAddedToState Test", () {
      blocTest("Adding Task successful",
          build: () => ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
            notificationRepository: NotificationFirebaseRepository(),
          ),
          act: (bloc) => bloc.add(AddTask(mockTask, "RHnHoZHH1eESZu8ypFlb")),
          wait: const Duration(milliseconds: 300),
          expect: []
      );

      blocTest("Adding Task with a null object task ",
          build: () => ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
            notificationRepository: NotificationFirebaseRepository(),
          ),
          act: (bloc) => bloc.add(AddTask(null, "RHnHoZHH1eESZu8ypFlb")),
          wait: const Duration(milliseconds: 300),
          expect: []
      );

      blocTest("Adding Task with an empty weddingID ",
          build: () => ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
            notificationRepository: NotificationFirebaseRepository(),
          ),
          act: (bloc) => bloc.add(AddTask(mockTask, "")),
          wait: const Duration(milliseconds: 300),
          expect: []
      );

      blocTest("Adding Task with a null object task and an empty weddingID ",
          build: () => ChecklistBloc(
            taskRepository: FirebaseTaskRepository(),
            notificationRepository: NotificationFirebaseRepository(),
          ),
          act: (bloc) => bloc.add(AddTask(null, "")),
          wait: const Duration(milliseconds: 300),
          expect: []
      );
  });

  group("MapTaskUpdatedToState Test", () {
    blocTest("Updating Task successful",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(UpdateTask(mockTask, "RHnHoZHH1eESZu8ypFlb")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );

    blocTest("Updating Task with a null object task ",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(UpdateTask(null, "RHnHoZHH1eESZu8ypFlb")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );

    blocTest("Updating Task with an empty weddingID ",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(UpdateTask(mockTask, "")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );

    blocTest("Updating Task with a null object task and an empty weddingID ",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(UpdateTask(null, "")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );
  });

  group("MapTaskDeletedToState Test", () {
    blocTest("Deleting Task successful",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(DeleteTask(mockTask, "RHnHoZHH1eESZu8ypFlb")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );

    blocTest("Deleting Task with a null object task ",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(DeleteTask(null, "RHnHoZHH1eESZu8ypFlb")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );

    blocTest("Delete Task with an empty weddingID ",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(DeleteTask(mockTask, "")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );

    blocTest("Deleting Task with a null object task and an empty weddingID ",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(DeleteTask(null, "")),
        wait: const Duration(milliseconds: 300),
        expect: []
    );
  });

  group("MapAddNotificationToState Test", () {
    blocTest("Adding Notification",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(ChangeToNotification(mockTask, notifications,"RHnHoZHH1eESZu8ypFlb", "adding")),
        wait: const Duration(milliseconds: 300),
        expect: [
          //TaskAdded(),
        ]
    );

    blocTest("Updating Notification",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(ChangeToNotification(mockTask, notifications,"RHnHoZHH1eESZu8ypFlb", "updating1")),
        wait: const Duration(milliseconds: 300),
        expect: [
          TaskUpdated(),
        ]
    );

    blocTest("Updating2 Notification",
        build: () => ChecklistBloc(
          taskRepository: FirebaseTaskRepository(),
          notificationRepository: NotificationFirebaseRepository(),
        ),
        act: (bloc) => bloc.add(ChangeToNotification(mockTask, notifications,"RHnHoZHH1eESZu8ypFlb", "updating2")),
        wait: const Duration(milliseconds: 300),
        expect: [
          TaskUpdated2(),
        ]
    );

  });
}
