import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Chỉnh Sửa Công Việc",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          Row(
            
          ),
        ],
      ),
    );
  }
}
