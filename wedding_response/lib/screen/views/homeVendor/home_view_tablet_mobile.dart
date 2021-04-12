import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_diary/bloc/guests/bloc.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/screen/widgets/image_show/image_show.dart';
import 'package:flutter_web_diary/screen/widgets/phone_input/phone_input.dart';

class HomeViewTabletMobile extends StatelessWidget {
  String weddingID;
  ValueChanged<Guest> onTapped;
  HomeViewTabletMobile({Key key,@required this.weddingID,@required this.onTapped}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.apps),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => new AlertDialog(
                            content: GoToDetailsButton(alertContext: context, weddingID: weddingID,onTapped: onTapped,),
                            actions: [
                              FlatButton(
                                  child: Text('Hủy'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ],
                          ));
                }),
            Text(
              "Nhấp vào đây",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ShowImage(src: "/weddingcard.png"),
            ],
          ),
        )
      ],
    );
  }
}
