import 'package:flutter/material.dart';

void main() {
  runApp(PersonalInfoPage());
}

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
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
            padding: const EdgeInsets.fromLTRB(40, 0, 30, 0),
            child: Text(
              "Thông tin cá nhân",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                  child: Icon(
                    Icons.assignment_ind_rounded,
                    size: 180,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: 'Họ và Tên',
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15)),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                        TextStyle(color: Colors.grey, fontSize: 15)),
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: 'Mật khẩu mới ',
                        labelStyle:
                        TextStyle(color: Colors.grey, fontSize: 15)),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: onSaveClick,
                    child: Text(
                      'Lưu',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void onSaveClick(){}