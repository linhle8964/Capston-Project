import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final int maxlines;
  final String hintText;
  String initialText;

  TextFieldCustom({Key key, @required this.hintText, @required this.maxlines, @required this.initialText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextFormField(
        maxLines: maxlines,
        autocorrect: true,
        initialValue: initialText,
        onSaved: (input) => initialText = input,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white60,
          border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.grey),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
