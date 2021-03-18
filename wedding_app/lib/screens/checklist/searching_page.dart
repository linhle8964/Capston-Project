import 'package:flutter/material.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/checklist/listview.dart';

class SearchingResultPage extends StatefulWidget {
  List<Task> tasks;
  String weddingID;
  SearchingResultPage({Key key, @required this.tasks, @required this.weddingID}) : super(key: key);
  @override
  _SearchingResultPageState createState() => _SearchingResultPageState();
}

class _SearchingResultPageState extends State<SearchingResultPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.tasks.length != 0) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Kết Quả',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListViewWidget(tasks: widget.tasks, weddingID: widget.weddingID,)
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Chưa có công việc tìm thấy',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }
  }
}
