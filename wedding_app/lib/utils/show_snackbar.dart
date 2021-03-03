import 'package:flutter/material.dart';

void showFailedSnackbar(BuildContext context, String message) {
  FocusScope.of(context).unfocus();
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            Icon(Icons.error),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
}

void showProcessingSnackbar(BuildContext context, String message) {
  FocusScope.of(context).unfocus();
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
}

void showSuccessSnackbar(BuildContext context, String message) {
  FocusScope.of(context).unfocus();
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            Icon(Icons.check),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
}
