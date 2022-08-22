import 'package:flutter/material.dart';

class WhiteCircularProgressIndicator extends StatelessWidget {

  const WhiteCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        )
    );
  }
}
