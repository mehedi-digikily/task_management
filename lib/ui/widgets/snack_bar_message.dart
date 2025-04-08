import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message, [errorMessage = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: errorMessage ? Colors.red : null,
    ),
  );
}
