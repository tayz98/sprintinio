import 'package:flutter/material.dart';

class SnackBarUtil {
  // Define the static method for showing an error SnackBar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
