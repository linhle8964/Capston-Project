import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_state.dart';
import 'package:wedding_app/bloc/guests/bloc.dart';
import 'package:wedding_app/bloc/guests/guests_bloc.dart';
import 'package:wedding_app/bloc/notification/bloc.dart';
import 'package:wedding_app/model/guest.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_dialog.dart';

class ListNotifications extends StatelessWidget {
  List<NotificationModel> notifications;
  String weddingID;
  ListNotifications({Key key,@required this.notifications,@required this.weddingID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Task detailTask = null;
    Guest detailGuest = null;
    if(notifications.isNotEmpty){
    return Container(
      margin: EdgeInsets.only(left: 0),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Ink(
            color: notifications[index].read
                ? Colors.grey[200]
                : null,
            child: BlocBuilder(
                cubit: BlocProvider.of<GuestsBloc>(context),
                builder: (context, state) {
                  if (notifications[index].type == 2) {
                    if (state is GuestsLoaded) {
                      List<Guest> guests = state.guests;
                      for (int i = 0; i < guests.length; i++) {
                        if (guests[i].id == notifications[index].detailsID)
                          detailGuest = guests[i];
                      }
                    }
                  }
                  return BlocBuilder(
                      cubit: BlocProvider.of<
                          ChecklistBloc>(context),
                      builder: (context, state) {
                        if (notifications[index].type ==1) {
                          if (state is TasksLoaded) {
                            List<Task> tasks = state.tasks;
                            for (int i = 0; i < tasks.length; i++) {
                              if (tasks[i].id == notifications[index].detailsID)
                                detailTask = tasks[i];
                            }
                          }
                        }
                        return Builder(
                          builder: (ctx) => ListTile(
                            contentPadding:
                            EdgeInsets.only(left: 12,),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) =>
                                      BlocProvider.value(
                                        value: BlocProvider.of<NotificationBloc>(ctx),
                                        child: NotificationDetailsDialog(
                                          detailObject: notifications[index].type == 1 ?  detailTask : detailGuest,
                                          notification: notifications[index],
                                          weddingID: weddingID,
                                        ),
                                      ));
                            },
                            title: Text(
                              notifications[index].content,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: notifications[index].read
                                      ? Colors.black : Colors.black38),
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 0),
                              child: Text(notifications[index].getDate(),
                                style: TextStyle(
                                    color: notifications[index].read
                                        ? Colors.black : Colors.black38),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: notifications[index].read
                                    ? Colors.black : Colors.black38,
                              ),
                              onPressed: () {
                                BlocProvider.of<NotificationBloc>(context)
                                  ..add(DeleteNotification(weddingID, notifications[index]));
                              },
                            ),
                          ),
                        );
                      });
                }),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 2,
          );
        },
      ),
    );
    }else{
      return Container(
          margin: EdgeInsets.only(left: 12,bottom: 20,top:20),
          child: Text("Bạn chưa có thông báo", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),));
    }
  }
}
