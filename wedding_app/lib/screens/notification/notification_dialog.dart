import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/notification/bloc.dart';
import 'package:wedding_app/model/notification.dart';
import 'package:wedding_app/screens/notification/guest_update_details.dart';
import 'package:wedding_app/screens/notification/task_time.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NotificationDetailsDialog extends StatefulWidget {
  var detailObject;
  String weddingID;
  NotificationModel notification;
  NotificationDetailsDialog({Key key, @required this.detailObject,
          @required this.notification, @required this.weddingID})
      : super(key: key);

  @override
  _NotificationDetailsDialogState createState() {
    return _NotificationDetailsDialogState();
  }
}

class _NotificationDetailsDialogState extends State<NotificationDetailsDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: widget.notification.type == 2 ? GuestDetailsPage(guest: widget.detailObject,) : TaskOverdue(task: widget.detailObject,) ,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Quay lại'),
          onPressed: () {
            if(widget.notification.read) widget.notification.read = false;
            BlocProvider.of<NotificationBloc>(context)..add(UpdateNotification(widget.notification, widget.weddingID));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
