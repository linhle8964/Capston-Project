import 'package:flutter/material.dart';
import 'package:flutter_web_diary/model/guest.dart';
import 'package:flutter_web_diary/screen/widgets/image_show/image_show.dart';
import 'package:flutter_web_diary/screen/widgets/phone_input/phone_input.dart';

class HomeViewDesktop extends StatelessWidget {
  String weddingID;
  ValueChanged<Guest> onTapped;
  HomeViewDesktop({Key key,@required this.weddingID,@required this.onTapped}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ShowImage(src: "/weddingcard.png"),
              Expanded(
                child: Center(
                  child: GoToDetailsButton(alertContext: null,weddingID: weddingID,onTapped: onTapped,),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
