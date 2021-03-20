import 'package:flutter/material.dart';

void showFailedSnackbar(BuildContext context, String message) {
  FocusScope.of(context).unfocus();
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        key: Key("fail_snackbar"),
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
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        key: Key("loading_snackbar"),
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
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        key: Key("success_snackbar"),
        duration: Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            Icon(
              Icons.check,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
}
