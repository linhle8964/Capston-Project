import 'package:flutter/material.dart';

TextButton buildButtonColumn(Key key,
    Color color, IconData icon, String label, Function function) {
  return TextButton(
    key: key,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
    onPressed: function.call,
  );
}
