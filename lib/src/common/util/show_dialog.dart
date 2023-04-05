import 'package:flutter/material.dart';

void showDialogAndDismiss(
    BuildContext context, String dialogTitle, String dialogMessage) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogMessage),
      );
    },
  );

  Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
}
