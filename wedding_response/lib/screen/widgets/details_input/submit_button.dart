import 'package:flutter/material.dart';
import 'package:flutter_web_diary/screen/views/success/success_page.dart';

class SubmitButtonCustom extends StatelessWidget {
  ValueChanged<bool> onTapped;
  SubmitButtonCustom({Key key, @required this.onTapped}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.input,color: Colors.red,
        ),
        onPressed: (){
          onTapped(true);
        },
        iconSize: 40,
      ),
    );
  }
}
