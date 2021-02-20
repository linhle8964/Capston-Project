import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding_app/bloc/category/bloc.dart';
import 'package:wedding_app/firebase_repository/firebase_category_repository.dart';
import 'package:wedding_app/repository/category_repository.dart';
import 'package:wedding_app/screens/edit_task/dropdown.dart';
import 'package:wedding_app/utils/border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  CategoryRepository categoryRepository = new FirebaseCategoryRepository();
  final _formKey = GlobalKey<FormState>();
  String _task = null, _dueDate = null, _note=null;
  bool _checkboxListTile = false;
  String _selectedDate= '20/10/2021';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year+3),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat('dd-MM-yyyy').format(d);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Thêm Công Việc",
          style: TextStyle(color: Colors.grey),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: 40,
              color: Colors.blue,
            ),
            onPressed: (){},
          ),
        ],
      ),
      body: BlocProvider<CategoryBloc>(
        create: (context) => CategoryBloc(categoryRepository: categoryRepository)
          ..add(CategoryLoadedSuccess()),
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
                    SizedBox(height: 5,),
                    Text(
                      'Hạn công việc',
                      style: new TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 5,),
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
                        SizedBox(width: 7.0,),
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
                    SizedBox(height: 5,),
                    Text(
                      'Loại công việc',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: 60,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.white,
                      ),
                      child: DropDown(),
                    ),
                    SizedBox(height: 20,),
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
}
