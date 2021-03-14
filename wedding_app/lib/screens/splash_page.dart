import 'package:flutter/material.dart';
import 'package:wedding_app/utils/hex_color.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#d86a77"),
      body: Center(
        child: Image(image: AssetImage('assets/app_icon/favicon-32x32.png')),
      ),
    );
  }
}
