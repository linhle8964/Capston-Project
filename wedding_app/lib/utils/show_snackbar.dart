import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, bool status) {
  FocusScope.of(context).unfocus();
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            status ? Icon(Icons.error) : CircularProgressIndicator(),
          ],
        ),
        backgroundColor: status ? Colors.red : null,
      ),
    );
}
