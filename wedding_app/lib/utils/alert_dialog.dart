import 'package:flutter/material.dart';
import 'file:///C:/Users/ADMIN/Documents/Git/Capston-Project/wedding_app/lib/const/widget_key.dart';

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
