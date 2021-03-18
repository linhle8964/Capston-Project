import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final Function function;
  final Color color;
  CustomButtom(this.text, this.function, this.color);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
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
