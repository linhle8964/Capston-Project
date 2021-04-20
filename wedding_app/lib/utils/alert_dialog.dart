import 'package:flutter/material.dart';
import 'package:wedding_app/const/widget_key.dart';

showSuccessAlertDialog(
    BuildContext context, String title, String message, Function function) {
  // set up the button
  Widget okButton = TextButton(
    key: Key(WidgetKey.alertDialogOkButtonKey),
    child: Text("OK"),
    onPressed: function,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    key: Key(WidgetKey.alertDialogKey),
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showErrorAlertDialog(
    BuildContext context, String title, String message, Function function) {
  // set up the button
  Widget okButton = TextButton(
    key: Key(WidgetKey.alertDialogOkButtonKey),
    child: Text("OK"),
    onPressed: function,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    key: Key(WidgetKey.alertDialogKey),
    title: Text(
      title,
      style: TextStyle(color: Colors.red),
    ),
    content: Text(
      message,
      style: TextStyle(
        color: Colors.red,
      ),
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
