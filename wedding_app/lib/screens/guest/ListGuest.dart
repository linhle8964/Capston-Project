import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Guest.dart';

class ListGuest extends StatelessWidget{
  final List<Guest> guests;
  ListGuest({this.guests});

  String getStatus(int stt){
    if(stt == 0)
      return "Chưa trả lời";
    else if(stt == 1)
      return "Sẽ tới";
    else return "Không tới";
  }

  List<Widget> _buildWidgetList(){
    return guests.map((eachGuest){
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        color: Colors.white,
        elevation: 10,
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10),),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top:10)),
                Text(
                  eachGuest.name,
                ),
                Text(
                  eachGuest.description,
                ),
                Padding(padding: EdgeInsets.only(bottom:10)),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      getStatus(eachGuest.status),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right:10)),
                ],
              ),
            ),
          ],
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20),
      height: MediaQuery.of(context).size.height - 140,
      child: ListView(
        children: this._buildWidgetList(),
      ),
    );
  }
}