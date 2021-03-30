import 'package:flutter/material.dart';
import 'package:wedding_app/utils/hex_color.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "VWED",
          style: TextStyle(
              color: hexToColor("#d86a77"),
              fontSize: 25.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
