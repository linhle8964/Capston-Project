import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MaxBudgetPage());
}

class MaxBudgetPage extends StatefulWidget {
  @override
  _MaxBudgetPageState createState() => _MaxBudgetPageState();
}

class _MaxBudgetPageState extends State<MaxBudgetPage> {
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
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  child: Center(
                    child: Container(
                      child: Text('Tổng chi phí hiện tại là:',style: TextStyle(fontSize: 25),),
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child:  Center(
                    child: Image.asset('assets/budget.png',height: 200.0,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 20, 30, 0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('200.000.000 đ',style: TextStyle(fontSize: 25),),
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
