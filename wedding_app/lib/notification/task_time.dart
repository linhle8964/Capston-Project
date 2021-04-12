import 'package:flutter/material.dart';
import 'package:wedding_app/model/task_model.dart';

class TaskOverdue extends StatelessWidget {
  Task task;
  TaskOverdue({Key key, @required this.task})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Đã đến hạn công việc",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10,),
        Text(task.name,
          style: TextStyle(fontSize: 17,),),
        SizedBox(height: 10,),
        Text(task.status? "Đã hoàn thành" : "Chưa hoàn thành",
          style: TextStyle(fontSize: 17,),),
        SizedBox(height: 10,),
        Text(task.getDate(),
          style: TextStyle(fontSize: 17,),)
      ],
    );
  }
}