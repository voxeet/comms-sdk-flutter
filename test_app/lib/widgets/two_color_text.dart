import 'package:flutter/material.dart';

class TwoColorText extends StatelessWidget {
  final String blackText;
  final String colorText;

  const TwoColorText({Key? key, required this.blackText, required this.colorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(blackText, style: const TextStyle(fontSize: 16)),
        Text(colorText,
            style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16
            )
        ),
      ],
    );
  }
}
