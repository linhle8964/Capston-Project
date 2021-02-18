import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_app/bloc/authentication/bloc.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          padding: const EdgeInsets.fromLTRB(80, 0, 30, 0),
          child: Text(
            "CÀI ĐẶT",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: onPersonInfoClick,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 210, 0),
                        child: Text(
                          'Thông tin cá nhân ',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: null,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(Icons.arrow_forward_ios_sharp),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                          child: Text(
                            'Thông tin mặc định ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 240, 0),
                          child: Text(
                            'Chi phí dự trù ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                          child: Text(
                            'Thông tin ngày cưới ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, "/invite_collaborator");
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                          child: Text(
                            'Kết nối với người ấy ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 260, 0),
                          child: Text(
                            'Ngôn Ngữ ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                          child: Text(
                            'Chính sách bảo mật ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 250, 0),
                          child: Text(
                            'Điều khoản ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Container(
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.white,
                        onPressed: onPersonInfoClick,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 260, 0),
                          child: Text(
                            'Quốc gia ',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text('App version 1.0.25'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      LoggedOut(),
                    );
                  },
                  child: Text(
                    'Đăng xuất ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  color: Colors.grey,
                  onPressed: onDeleteWeddingClick,
                  child: Text(
                    'Xóa đám cưới ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

void onPersonInfoClick() {}
void onLogOutClick() {}
void onDeleteWeddingClick() {}
