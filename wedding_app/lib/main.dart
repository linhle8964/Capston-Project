import 'package:flutter/material.dart';
import 'package:wedding_app/demo_page.dart';
import 'package:wedding_app/screens/navigator/navigator.dart';
import 'package:wedding_app/utils/hex_color.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/first': (context) => DemoPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => DemoPage(),
        '/third': (context) => DemoPage(),
        '/fourth': (context) => DemoPage(),
        '/fifth': (context) => DemoPage(),
      },
      title: 'Wedding App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavigatorDemo(),
    );
  }
}
