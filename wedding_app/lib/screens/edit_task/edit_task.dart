import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/category/category_bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/utils/hex_color.dart';
import 'package:wedding_app/utils/border.dart';
import 'package:intl/intl.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';

class EditTaskPage extends StatefulWidget {
  Task task;
  String weddingID;
  EditTaskPage({Key key, @required this.task, @required this.weddingID})
      : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String _task, _note, _category;
  bool _checkboxListTile = false;
  String _selectedDate = new DateFormat('dd-MM-yyyy').format(DateTime.now());
  DateTime _dueDate;

  @override
  void initState() {
    _task = widget.task.name;
    _selectedDate = new DateFormat('dd-MM-yyyy').format(widget.task.dueDate);
    _category = widget.task.category;
    _checkboxListTile = widget.task.status;
    _note = widget.task.note;
    _dueDate = widget.task.dueDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat('dd-MM-yyyy').format(d);
        _dueDate = d;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#d86a77"),
        title: Text(
          "Chỉnh Sửa Công Việc",
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => PersonDetailsDialog(
                  message: "Bạn có muốn thoát",
                  onPressedFunction: () {
                    Navigator.of(context).pop();
                  },
                ));
          },
        ),

        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: Icon(
                Icons.check,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => PersonDetailsDialog(
                          message: "Bạn đang chỉnh sửa công việc",
                          onPressedFunction: () {
                            updateTask(ctx);
                          },
                        ));
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: _task,
                        decoration: InputDecoration(
                          labelText: "Công Việc",
                          focusedBorder: focusedBorder,
                          enabledBorder: enabledBorder,
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (input) =>
                            input == null ? 'Hãy điền công việc của bạn' : null,
                        onSaved: (input) => _task = input,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Hạn công việc',
                        style: new TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0, top: 4.0),
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedDate,
                                          style: new TextStyle(
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        tooltip: 'Tap to open date picker',
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          SizedBox(
                            height: 60,
                            width: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(),
                              ),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.all(0),
                                activeColor: Colors.blue,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text('Chưa hoàn thành'),
                                value: _checkboxListTile,
                                onChanged: (value) {
                                  setState(() {
                                    _checkboxListTile = !_checkboxListTile;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Loại công việc',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.white,
                        ),
                        child: Builder(
                          builder: (context) => BlocBuilder(
                            cubit: BlocProvider.of<CateBloc>(context),
                            builder: (context, state) {
                              List<String> categories = [];
                              List<Category> categoryObjects = [];
                              if (state is TodosLoaded) {
                                categoryObjects = state.cates;
                                for (int i = 0;
                                    i < categoryObjects.length;
                                    i++) {
                                  categories.add(
                                      categoryObjects[i].cateName.toString());
                                }
                              } else if (state is TodosLoading) {
                              } else if (state is TodosNotLoaded) {}
                              return DropdownButton<String>(
                                isExpanded: true,
                                value: _category,
                                icon: Icon(Icons.keyboard_arrow_down_outlined),
                                iconSize: 40,
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _category = newValue;
                                  });
                                },
                                items: categories.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        maxLines: 8,
                        initialValue: _note,
                        decoration: InputDecoration(
                          labelText: "Ghi chú",
                          focusedBorder: focusedBorder,
                          enabledBorder: enabledBorder,
                          fillColor: Colors.white,
                          filled: true,
                          alignLabelWithHint: true,
                        ),
                        onSaved: (input) => _note = input,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Colors.red,
                              shape: CircleBorder(),
                            ),
                            child: Builder(
                              builder: (ctx) => IconButton(
                                icon: Icon(Icons.delete_forever_outlined),
                                color: Colors.white,
                                iconSize: 40,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          PersonDetailsDialog(
                                            message: "Bạn đang xóa",
                                            onPressedFunction: () {
                                              deleteTask(ctx);
                                            },
                                          ));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
          ),
        ),
      ),
    );
  }

  void deleteTask(context) {
    if (_formKey.currentState.validate() && _category != null) {
      _formKey.currentState.save();
      BlocProvider.of<ChecklistBloc>(context)
        ..add(DeleteTask(widget.task, widget.weddingID));
      Navigator.pop(context);
    } else if (_task == null) {
      showFailedSnackbar(context, 'Bạn chưa điền tên công việc');
    }
  }

  void updateTask(context) {
    _formKey.currentState.save();
    Task task = new Task(
        id: widget.task.id,
        name: _task,
        dueDate: _dueDate,
        status: _checkboxListTile,
        note: _note,
        category: _category);
    if (_task != null && _task.trim().isNotEmpty) {
      if (task == widget.task) {
        showFailedSnackbar(context, "Bạn chưa thay đổi tên công việc!!!");
        return;
      }
      BlocProvider.of<ChecklistBloc>(context)
        ..add(UpdateTask(task, widget.weddingID));
      Navigator.pop(context);
    } else {
      showFailedSnackbar(context, "Có lỗi xảy ra");
    }
  }
}
