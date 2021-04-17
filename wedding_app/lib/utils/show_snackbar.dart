import 'package:flutter/material.dart';
import 'file:///F:/Code Tool/Capston-Project/wedding_app/lib/const/widget_key.dart';

void showFailedSnackbar(BuildContext context, String message) {
  FocusScope.of(context).unfocus();
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        key: Key(WidgetKey.failedSnackbarKey),
        duration: Duration(seconds: 1),
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
        key: Key(WidgetKey.loadingSnackbarKey),
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
        key: Key(WidgetKey.successSnackbarKey),
        duration: Duration(seconds: 1),
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
