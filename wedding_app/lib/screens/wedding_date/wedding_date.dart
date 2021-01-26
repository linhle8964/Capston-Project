import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(WeddingDate());
}

class WeddingDate extends StatefulWidget {
  @override
  _WeddingDateState createState() => _WeddingDateState();
}

class _WeddingDateState extends State<WeddingDate> {
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
                  "NGÀY CƯỚI",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Center(
                        child: Container(
                          child: Text('Ngày cưới dự định:',style: TextStyle(fontSize: 25),),
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child:  Center(
                      child: Image.asset('assets/calender.jpg',height: 200.0,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 20, 40, 0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('19-07-2021',style: TextStyle(fontSize: 25),),
                          FlatButton(
                            onPressed: onEditClick,
                            child: Image.asset('assets/edit.png',height: 50.0,),)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
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
            )
        ));
  }
}
void onEditClick(){}
void onSaveClick(){}
