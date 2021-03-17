import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String src;
  ShowImage({Key key, @required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 500,
      child: new Image.asset(
        src,
        fit: BoxFit.cover,
      ),
    );
  }
}
