import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  final bool fillWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.deepPurple,
    this.fillWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    var minSize =
        fillWidth ? const Size(double.maxFinite, 40) : const Size(0, 40);
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            minimumSize: minSize,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: color, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          text,
          style: TextStyle(color: color),
        ));
  }
}
