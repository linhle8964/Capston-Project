import 'package:flutter/material.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/checklist/listview.dart';

class SearchingResultPage extends StatefulWidget {
  List<Task> tasks;

  SearchingResultPage({Key key, @required this.tasks}) : super(key: key);
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(
                            0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListViewWidget(tasks: widget.tasks)
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
