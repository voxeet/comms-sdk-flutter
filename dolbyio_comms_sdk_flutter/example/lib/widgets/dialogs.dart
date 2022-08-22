import 'package:flutter/material.dart';

class ViewDialogs {
  static Future<void> dialog({
    required BuildContext context,
    required String title,
    required String body,
    String okText = "OK",
    String? cancelText,
    Function(bool)? result,
  }) async {
    //check bundles
    if (true) {
      await showDialog(
        context: context,
        builder: (_) {
          List<TextButton> cancelButton = cancelText != null ? [
              TextButton(
                onPressed: () {
                  result?.call(false);
                  Navigator.pop(context);
                },
                child: Text(cancelText),
              )
            ] : [];
          var buttons = cancelButton + [
            TextButton(
              onPressed: () {
                result?.call(true);
                Navigator.pop(context);
              },
              child: Text(okText),
            )
          ];

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(title),
            content: SingleChildScrollView(child: Text(body)),
            actions: buttons,
          );
        },
        barrierDismissible: false,
      );
    }
  }
}
