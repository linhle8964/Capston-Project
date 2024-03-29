import 'package:flutter/material.dart';

class InputFieldArea extends StatefulWidget {
  final String hint;
  bool obscure;
  final Icon icon;
  final TextEditingController controller;
  final String errorText;
  final String labelText;
  final bool isPassword;
  InputFieldArea(
      {Key key,
      this.hint,
      this.obscure,
      this.icon,
      this.controller,
      this.errorText,
      this.labelText,
      this.isPassword})
      : super(key: key);
  @override
  _InputFieldAreaState createState() => _InputFieldAreaState();
}

class _InputFieldAreaState extends State<InputFieldArea> {
  @override
  Widget build(BuildContext context) {
    return (new Container(
      child: new TextField(
        controller: widget.controller,
        obscureText: widget.obscure,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: new InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.blue[300]),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          labelText: widget.labelText,
          errorText: widget.errorText,
          errorStyle: TextStyle(
            color: Colors.red,
          ),
          suffixIcon: new IconButton(
            icon: widget.icon,
            onPressed: () {
              setState(() {
                if (widget.isPassword) {
                  widget.obscure = !widget.obscure;
                }
              });
            },
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    ));
  }
}
