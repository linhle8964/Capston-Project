import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showPass = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  var _emailError="E-mail không hợp lệ";
  var _passErr="Mật khẩu phải trên 6 kí tự";
  var _emailInvalid=false;
  var _passInvalid=false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      constraints: BoxConstraints.expand(),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Container(
              child: FlutterLogo(),
              width: 70,
              height: 70,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xffd8d8d8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              "Đăng nhập để bắt đầu thực hiện đám cưới của bạn nào.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    errorText: _emailInvalid ? _emailError: null,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: <Widget>[
                TextField(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  controller: _passController,
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      errorText: _passInvalid ? _passErr: null,
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
                GestureDetector(
                  onTap: onToggleShowPass,
                  child: Text(
                    _showPass ? "Ẩn Mật khẩu" : "Hiện Mật Khẩu",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: SizedBox(
              width: double.infinity,
              height: 30,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: onLogInClick,
                child: Text(
                  'Đăng Nhập ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: SizedBox(
              width: double.infinity,
              height: 30,
              child: RaisedButton(
                color: Colors.blue,
                onPressed: onSignInClick,
                child: Text(
                  'Đăng Kí ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),

          Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  RaisedButton(
                    onPressed: onLogInFacebookClick,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      'Facebook ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  RaisedButton(
                    onPressed: onLogInGmailClick,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      'Gmail ',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              )),

          Padding(
            padding: const EdgeInsets.fromLTRB(90, 0, 0, 10),
            child: Container(
              height: 80,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Quên Mật Khẩu?",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    )));
  }

  void onSignInClick() {
    setState(() {
      if(_emailController.text.length <6 || !_emailController.text.contains("@")){
        _emailInvalid=true;
      }else{
        _emailInvalid=false;
      }
      if(_passController.text.length <6 ){
        _passInvalid=true;
      }else{
        _passInvalid=false;
      }
      if(_emailInvalid==false && _passInvalid==false){

      }
    });
  }
  void onLogInClick() {
    setState(() {
      if(_emailController.text.length <6 || !_emailController.text.contains("@")){
        _emailInvalid=true;
      }else{
        _emailInvalid=false;
      }
      if(_passController.text.length <6 ){
        _passInvalid=true;
      }else{
        _passInvalid=false;
      }
      if(_emailInvalid==false && _passInvalid==false){

      }
    });
  }

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }
  void onLogInFacebookClick(){}
  void onLogInGmailClick(){}
}
