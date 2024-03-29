import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/const/widget_key.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/edit_task/edit_task.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';

class ListViewWidget extends StatefulWidget {
  List<Task> tasks;
  String weddingID;
  ListViewWidget({Key key, @required this.tasks, @required this.weddingID})
      : super(key: key);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.tasks != null) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          String widgetKey = WidgetKey.taskItemKey + index.toString();
          return Card(
            key: Key(widgetKey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            elevation: 5,
            child: ListTile(
              title: Text(
                widget.tasks[index].name,
                key: UniqueKey(),
                style: TextStyle(
                  fontSize: 18,
                  color: widget.tasks[index].dueDate.isBefore(DateTime.now())
                      ? Colors.red
                      : Colors.black,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Text(widget.tasks[index].getDate(),
                  style: TextStyle(
                  color: widget.tasks[index].dueDate.isBefore(DateTime.now())
                      ? Colors.red
                      : Colors.black,
                ),
                ),
              ),
              trailing: Theme(
                data: ThemeData(
                  primarySwatch: Colors.red,
                  unselectedWidgetColor:
                      widget.tasks[index].dueDate.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.black,
                  // Your color
                ),
                child: Checkbox(
                  activeColor:
                      widget.tasks[index].dueDate.isBefore(DateTime.now())
                          ? Colors.red
                          : Colors.blue,
                  value: widget.tasks[index].status,
                  onChanged: (bool value) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => PersonDetailsDialog(
                              message:
                                  "Bạn đang thay đổi trạng thái của công việc",
                              onPressedFunction: () {
                                updateStatus(index);
                              },
                            ));
                  },
                ),
              ),
              onTap: () {
                var state = BlocProvider.of<ChecklistBloc>(context).state;
                if(state is TasksSearching){
                  Navigator.pop(context);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CateBloc>(context),
                            child: BlocProvider.value(
                                value: BlocProvider.of<ChecklistBloc>(context),
                                child: EditTaskPage(
                                    task: widget.tasks[index],
                                    weddingID: widget.weddingID)),
                          )),
                );
              },
            ),
          );
        },
      );
    } else {
      return Text("Bạn vừa xóa công việc này");
    }
  }

  void updateStatus(int index) {
    Task oldTask = widget.tasks[index];
    Task task = new Task(
        id: oldTask.id,
        name: oldTask.name,
        dueDate: oldTask.dueDate,
        status: !oldTask.status,
        category: oldTask.category,
        note: oldTask.note);
    BlocProvider.of<ChecklistBloc>(context)
      ..add(Update2Task(task, widget.weddingID));
  }
}
