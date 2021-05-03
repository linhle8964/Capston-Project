import 'package:flutter/material.dart';

Container buildInfoColumn(
    BuildContext context, Color color, String label, String amount) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Container(
      height: height / 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: width / 3,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: width / 3,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Text(
                amount,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ));
}
