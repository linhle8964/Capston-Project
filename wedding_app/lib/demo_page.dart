import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  final String string;

  const DemoPage ({ Key key, this.string }): super(key: key);
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(widget.string)),
    );
  }
}
