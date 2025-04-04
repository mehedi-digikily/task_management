import 'package:flutter/material.dart';

void snackMessage(BuildContext context, String message, [errorMessage = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: errorMessage ? Colors.red : null,
    ),
  );
}
