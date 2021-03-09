import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/bloc/category/category_bloc.dart';
import 'package:wedding_app/bloc/checklist/bloc.dart';
import 'package:wedding_app/bloc/checklist/checklist_bloc.dart';
import 'package:wedding_app/model/category.dart';
import 'package:wedding_app/model/task_model.dart';
import 'package:wedding_app/utils/border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wedding_app/utils/show_snackbar.dart';
import 'package:wedding_app/widgets/confirm_dialog.dart';
import 'package:wedding_app/utils/hex_color.dart';

class AddTaskPage extends StatefulWidget {
  String weddingID;
  AddTaskPage({Key key, @required this.weddingID}) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String _task = null, _note = null, _category = null;
  bool _checkboxListTile = false;
  String _selectedDate = new DateFormat('dd-MM-yyyy').format(DateTime.now());
  DateTime _dueDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
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
          "Thêm Công Việc",
          style: TextStyle(color: Colors.white),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
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
                          message: "Bạn đang thêm công việc",
                          onPressedFunction: () {
                            addNewTask(ctx);
                          },
                        ));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
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
                              controlAffinity: ListTileControlAffinity.leading,
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
                              for (int i = 0; i < categoryObjects.length; i++) {
                                categories.add(
                                    categoryObjects[i].cateName.toString());
                              }
                              // widget.dropdownValue = categories.length !=0? categories[0].toString()
                              //    : widget.dropdownValue;
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
                  ])),
        ),
      ),
    );
  }

  void addNewTask(context) {
    _formKey.currentState.save();
    Task task = new Task(
        name: _task,
        dueDate: _dueDate,
        status: _checkboxListTile,
        note: _note,
        category: _category);
    print(task.toString());
    if (_task != null && _category != null && _task.trim().isNotEmpty) {
      BlocProvider.of<ChecklistBloc>(context)
        ..add(AddTask(task, widget.weddingID));
      Navigator.pop(context);
    } else {
      showFailedSnackbar(context, "Có lỗi xảy ra");
    }
  }
}
