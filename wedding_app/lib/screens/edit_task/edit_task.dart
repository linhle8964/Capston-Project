import 'package:flutter/material.dart';
import 'package:wedding_app/screens/edit_task/dropdown.dart';

import 'package:wedding_app/utils/border.dart';
import 'package:intl/intl.dart';

class EditTaskPage extends StatefulWidget {
  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
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
          "Chỉnh Sửa Công Việc",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: Container(
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
                  SizedBox(height: 10,),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.red,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete_forever_outlined),
                            color: Colors.white,
                            iconSize: 40,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.only(left:0.0, right: 40.0),
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.cancel_outlined),
                                color: Colors.white,
                                iconSize: 30,
                                onPressed: () {},
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'CANCEL',
                                     style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.only(right: 0.0, left: 40.0),
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'SAVE',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios_outlined),
                                color: Colors.white,
                                iconSize: 30,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )

                ])),
      ),
    );
  }
}
