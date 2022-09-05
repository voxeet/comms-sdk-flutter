import 'package:flutter/material.dart';

class StatusSnackbar{

  static const snackBarDisplayDuration = Duration(milliseconds: 700);

  static buildSnackbar(BuildContext context, String body) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(body),
      duration: snackBarDisplayDuration,
      backgroundColor: Colors.deepPurple,
    ));
  }
}
