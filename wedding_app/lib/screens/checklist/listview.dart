import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/screens/add_task/add_task.dart';
import 'package:wedding_app/screens/edit_task/edit_task.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:wedding_app/widgets/loading_indicator.dart';

class ListViewWidget extends StatefulWidget {
  List<Task> tasks;

  ListViewWidget({Key key,@required this.tasks}) : super(key: key);

  @override
  _ListViewWidgetState createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  bool checkbox = false;

  Widget build(BuildContext context) {
    return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      widget.tasks[index].name,
                      key: UniqueKey(),
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    trailing: Checkbox(
                      activeColor: Colors.lightBlue,
                      value: widget.tasks[index].status,
                      onChanged: (bool value) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            child: PersonDetailsDialog(
                              message:"Bạn đang thay đổi trạng thái của công việc",
                              onPressedFunction: (){updateStatus(index);},
                            ));
                      },
                    ),
                     onTap: () {
                       Navigator.push(
                        context,
                         MaterialPageRoute(
                             builder: (_) => BlocProvider.value(
                               value: BlocProvider.of<CateBloc>(context),
                              child: BlocProvider.value(
                                   value:
                                   BlocProvider.of<ChecklistBloc>(context),
                                   child: EditTaskPage(
                                     task: widget.tasks[index],
                                   )),
                             )),
                       );
                     },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 2.0,
                  );
                },
              );
  }
  
  void updateStatus(int index){
    Task oldTask = widget.tasks[index];
    Task task = new Task(id: oldTask.id
        , name: oldTask.name
        , dueDate: oldTask.dueDate
        , status: !oldTask.status
        , category: oldTask.category
        , note: oldTask.note);
    BlocProvider.of<ChecklistBloc>(context)..add(Update2Task(task));
  }
}
