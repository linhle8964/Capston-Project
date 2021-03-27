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
import 'package:flutter_bloc/flutter_bloc.dart';

class ListNotifications extends StatefulWidget {
  List<NotificationModel> notifications;
  String weddingID;
  ListNotifications({Key key,@required this.notifications,@required this.weddingID})
      : super(key: key);
  @override
  _ListNotificationsState createState() => _ListNotificationsState();
}

class _ListNotificationsState extends State<ListNotifications> {
  Widget listView(Guest detailGuest, Task detailTask, int length){
    return Container(
      margin: EdgeInsets.only(left: 0),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemCount: length,
        itemBuilder: (context, index) {
          return Ink(
            color: widget.notifications[index].read
                ? Colors.grey[200]
                : null,
            child: BlocBuilder(
                cubit: BlocProvider.of<GuestsBloc>(context),
                builder: (context, state) {
                  if (widget.notifications[index].type == 2) {
                    if (state is GuestsLoaded) {
                      List<Guest> guests = state.guests;
                      for (int i = 0; i < guests.length; i++) {
                        if (guests[i].id == widget.notifications[index].detailsID)
                          detailGuest = guests[i];
                      }
                    }
                  }
                  return BlocBuilder(
                      cubit: BlocProvider.of<
                          ChecklistBloc>(context),
                      builder: (context, state) {
                        if (widget.notifications[index].type ==1) {
                          if (state is TasksLoaded) {
                            List<Task> tasks = state.tasks;
                            for (int i = 0; i < tasks.length; i++) {
                              if (tasks[i].id == widget.notifications[index].detailsID)
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
                                          detailObject: widget.notifications[index].type == 1 ?  detailTask : detailGuest,
                                          notification: widget.notifications[index],
                                          weddingID: widget.weddingID,
                                        ),
                                      ));
                            },
                            title: Text(
                              widget.notifications[index].content,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: widget.notifications[index].read
                                      ? Colors.black : Colors.black38),
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 0),
                              child: Text(widget.notifications[index].getDate(),
                                style: TextStyle(
                                    color: widget.notifications[index].read
                                        ? Colors.black : Colors.black38),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: widget.notifications[index].read
                                    ? Colors.black : Colors.black38,
                              ),
                              onPressed: () {
                                BlocProvider.of<NotificationBloc>(context)
                                  ..add(DeleteNotification(widget.weddingID, widget.notifications[index]));
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
  }

  int time;
  @override
  void initState() {
    time =1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Task detailTask = null;
    Guest detailGuest = null;
    if(widget.notifications.isNotEmpty){
      return BlocBuilder(
          cubit: BlocProvider.of<NotificationBloc>(context),
          builder: (context, state)  {
            if( widget.notifications.length <= 3*time){
              return listView(detailGuest, detailTask, widget.notifications.length);
            }
            else{
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listView(detailGuest, detailTask, 3*time),
                  TextButton(
                      onPressed: (){
                        setState(() {
                          time++;
                        });
                      },
                      child: Text("Xem thêm...", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),))
                ],
              );
            }
          }
      );
    }else{
      return Container(
          margin: EdgeInsets.only(left: 12,bottom: 20,top:20),
          child: Text("Bạn chưa có thông báo", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),));
    }
  }
}



