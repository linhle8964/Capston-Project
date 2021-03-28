import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final Function function;
  final Color color;
  CustomButtom(Key key, this.text, this.function, this.color) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color),
          onPressed: function,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
