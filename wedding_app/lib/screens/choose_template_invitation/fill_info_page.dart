import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FillInfoPage extends StatefulWidget {
  @override
  _FillInfoPageState createState() => _FillInfoPageState();
}

class _FillInfoPageState extends State<FillInfoPage> {
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
                  "TỔNG CHI PHÍ",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            body: Container(

            )
        ));
  }
}
void onEditClick(){}
void onSaveClick(){}
