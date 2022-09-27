import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final Widget widgetText;
  final void Function()? onPressed;
  final Color color;

  const PrimaryButton(
      {super.key,
      required this.widgetText,
      required this.onPressed,
      this.color = Colors.blue});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.maxFinite, 40),
            primary: widget.color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
        child: widget.widgetText);
  }
}
