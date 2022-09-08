import 'package:flutter/material.dart';

class StatusSnackbar{

  static buildSnackbar(BuildContext context, String body, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(body),
      duration: duration,
      backgroundColor: Colors.deepPurple,
    ));
  }
}
