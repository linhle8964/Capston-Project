import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wedding_app/model/template_card.dart';

import 'invitation_card_page.dart';

class FillInfoPage extends StatefulWidget {
  final TemplateCard template;
  const FillInfoPage({Key key, @required this.template}): super (key: key);
  @override
  _FillInfoPageState createState() => _FillInfoPageState();
}

class _FillInfoPageState extends State<FillInfoPage> {
  TemplateCard get template => widget.template;
  TextEditingController _brideNameController = TextEditingController();
  TextEditingController _groomNameController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  var _errorMess = '';
  var _brideNameInvalid = false;
  var _groomNameInvalid = false;
  var _placeInvalid = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: null,
              ),
              title: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 30, 0),
                child: Text(
                  "Thông Tin Trên Thiệp",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            body: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          controller: _brideNameController,
                          decoration: InputDecoration(
                              labelText: 'Tên Cô Dâu',
                              errorText: _brideNameInvalid? _errorMess: null,
                              labelStyle: TextStyle(
                                  color: Colors.grey, fontSize: 15)),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          controller: _groomNameController,
                          decoration: InputDecoration(
                              labelText: 'Tên Chú Rể',
                              errorText: _groomNameInvalid? _errorMess: null,
                              labelStyle: TextStyle(
                                  color: Colors.grey, fontSize: 15)),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          controller: _dateTimeController,
                          decoration: InputDecoration(
                              labelText: 'Thời gian ',
                              labelStyle: TextStyle(
                                  color: Colors.grey, fontSize: 15)),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextField(
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          controller: _placeController,
                          decoration: InputDecoration(
                              labelText: 'Địa điểm',
                              errorText: _placeInvalid? _errorMess: null,
                              labelStyle: TextStyle(
                                  color: Colors.grey, fontSize: 15)),
                        )),
                    ElevatedButton(
                      child: Text('Open route'),
                      onPressed: onSaveClick,
                    ),
                  ]
            )
            )
        ));
  }
  void onSaveClick(){
    setState(() {
      final alphanumeric = RegExp(r'^[^0-9\,!@#$%^&*()_+=-]+$');
      if (_brideNameController.text.length > 32  ){
        _brideNameInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_brideNameController.text.length < 2 ){
      _brideNameInvalid = true;
      _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!alphanumeric.hasMatch(_brideNameController.text)){
        _brideNameInvalid = true;
        _errorMess= 'Thông tin nhập không đúng';
      }else if(template.name.endsWith('3') && _brideNameController.text.length>15){
        _brideNameInvalid = true;
        _errorMess= 'Mẫu thiệp mời không phù hợp với độ dài của tên';
      } else {
        _brideNameInvalid = false;
      }
      if (_groomNameController.text.length > 32  ){
        _groomNameInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_groomNameController.text.length < 2 ){
        _groomNameInvalid = true;
        _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!alphanumeric.hasMatch(_groomNameController.text)){
        _groomNameInvalid = true;
        _errorMess= 'Thông tin nhập không đúng';
      }else if(template.name.endsWith('3') && _groomNameController.text.length>15){
        _groomNameInvalid = true;
        _errorMess= 'Mẫu thiệp mời không phù hợp với độ dài của tên';
      }else {
        _groomNameInvalid = false;
      }
      if (_placeController.text.length > 32  ){
        _placeInvalid = true;
        _errorMess = 'Số lượng kí tự quá nhiều';
      }else if(_placeController.text.length < 2 ){
        _brideNameInvalid = true;
        _errorMess= 'Số lượng kí tự quá ngắn';
      }else if(!alphanumeric.hasMatch(_placeController.text)){
        _placeInvalid = true;
        _errorMess= 'Thông tin nhập không đúng';
      }else {
        _placeInvalid = false;
      }
      if(_brideNameInvalid == false && _groomNameInvalid == false && _placeInvalid == false){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InvitationCardPage(template:template,brideName: _brideNameController.text,groomName: _groomNameController.text,dateTime: _dateTimeController.text,place: _placeController.text,)),
        );
      }
    });
  }
}

