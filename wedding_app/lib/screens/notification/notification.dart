import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/bloc/notification/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_task_repository.dart';
import 'package:wedding_app/firebase_repository/guest_firebase_repository.dart';
import 'package:wedding_app/firebase_repository/notification_firebase_repository.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/utils/get_data.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:wedding_app/screens/notification/list_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wedding_app/widgets/receive_notification.dart';

class NotificationPage extends StatefulWidget {
  String weddingID;
  NotificationPage({Key key, @required this.weddingID}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

int time1 = 1;
int time2 = 1;

class _NotificationPageState extends State<NotificationPage> {
  Future<bool> _onWillPop() async {
    var state = BlocProvider.of<NotificationBloc>(context).state;
    if (state is NotificationsLoaded) {
      List<NotificationModel> notifications = state.notifications;
      BlocProvider.of<NotificationBloc>(context)
        ..add(UpdateNewNotifications(widget.weddingID, notifications));
    }
    return true;
  }
void showNotification(){
  NotificationManagement.flutterLocalNotificationsPlugin.show(0, "testing", "demo", NotificationDetails(
    android: AndroidNotificationDetails(
      NotificationManagement.channel.id,
      NotificationManagement.channel.name,
      NotificationManagement.channel.description,
      importance: Importance.high,
      color: Colors.blue,
      playSound: true,
      icon: "@mipmap/ic_launcher"
    )
  ));
}
  @override
  void initState() {
    time1 = 1;
    time2 = 1;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android= message.notification?.android;
      if(notification !=null&& android!=null){
        NotificationManagement.flutterLocalNotificationsPlugin.show(notification.hashCode, notification.title, notification.body,NotificationDetails(
            android: AndroidNotificationDetails(
              NotificationManagement.channel.id,
              NotificationManagement.channel.name,
              NotificationManagement.channel.description,
              icon: "@mipmap/ic_launcher"
            )
        ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("check");
      RemoteNotification notification= message.notification;
      AndroidNotification android= message.notification?.android;
      if(notification !=null&& android!=null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(notification.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body)
                ],
              ),
            ),
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder(
          future: getWeddingID(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final String weddingID = snapshot.data;
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ChecklistBloc>(create: (BuildContext context) {
                    return ChecklistBloc(
                      taskRepository: FirebaseTaskRepository(),
                      notificationRepository: NotificationFirebaseRepository(),
                    )..add(LoadSuccess(weddingID));
                  }),
                  BlocProvider<GuestsBloc>(create: (BuildContext context) {
                    return GuestsBloc(
                      guestsRepository: FirebaseGuestRepository(),
                    )..add(LoadGuests(weddingID));
                  }),
                ],
                child: Builder(
                  builder: (context) => BlocListener(
                    cubit: BlocProvider.of<NotificationBloc>(context),
                    listener: (context, state) {
                      if (state is NotificationDeleted) {
                        BlocProvider.of<NotificationBloc>(context)
                          ..add(LoadNotifications(weddingID));
                        showSuccessSnackbar(
                            context, "bạn đã xóa thông báo thành công");
                      }
                      if (state is AllNotificationsDeleted) {
                        BlocProvider.of<NotificationBloc>(context)
                          ..add(LoadNotifications(weddingID));
                        showSuccessSnackbar(
                            context, "bạn đã xóa tất cả thông báo");
                      }
                      if (state is NotificationUpdated) {
                        BlocProvider.of<NotificationBloc>(context)
                          ..add(LoadNotifications(weddingID));
                      }
                    },
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: hexToColor("#d86a77"),
                        title: Center(child: Text('Thông Báo')),
                        actions: [
                          Builder(
                            builder: (ctx) => Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.clear_all,
                                    size: 27,
                                  ),
                                  onPressed: () {
                                   showNotification();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      body: Builder(
                        builder: (context) => BlocBuilder(
                            cubit: BlocProvider.of<NotificationBloc>(context),
                            builder: (context, state) {
                              if (state is NotificationsLoaded) {
                                List<NotificationModel> notifications =
                                    state.notifications;
                                List<NotificationModel> newNotifications = [];
                                List<NotificationModel> oldNotifications = [];
                                for (int i = 0; i < notifications.length; i++) {
                                  if (notifications[i].isNew)
                                    newNotifications.add(notifications[i]);
                                  else
                                    oldNotifications.add(notifications[i]);
                                }
                                if (notifications.isNotEmpty) {
                                  return SingleChildScrollView(
                                    physics: ScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListNotifications(
                                          notifications: newNotifications,
                                          weddingID: weddingID,
                                          isOld: 1,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child: Text(
                                              "Trước đó",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ListNotifications(
                                          notifications: oldNotifications,
                                          weddingID: weddingID,
                                          isOld: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      "Bạn chưa có thông báo nào",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  _deleteAllNotifications(String weddingID, var ctx) {
    var state = BlocProvider.of<NotificationBloc>(ctx).state;
    if (state is NotificationsLoaded) {
      List<NotificationModel> notifications = state.notifications;
      if (notifications.isEmpty || notifications == null) {
        showFailedSnackbar(context, "Không có thông báo nào để xóa");
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => PersonDetailsDialog(
                  message: "Bạn đang xóa tất cả thông báo",
                  onPressedFunction: () {
                    BlocProvider.of<NotificationBloc>(ctx)
                      ..add(DeleteAllNotifications(weddingID, notifications));
                  },
                ));
      }
    }
  }
}
