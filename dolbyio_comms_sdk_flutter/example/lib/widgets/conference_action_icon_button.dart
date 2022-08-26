import 'package:flutter/material.dart';

class ConferenceActionIconButton extends StatefulWidget {
  final Widget iconWidget;
  final Color backgroundIconColor;
  final void Function() onPressedIcon;

  const ConferenceActionIconButton({Key? key, required this.iconWidget, required this.backgroundIconColor, required this.onPressedIcon}) : super(key: key);

  @override
  _ConferenceActionIconButtonState createState() => _ConferenceActionIconButtonState();
}

class _ConferenceActionIconButtonState extends State<ConferenceActionIconButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
                onPressed: widget.onPressedIcon,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  primary: widget.backgroundIconColor,
                ),
                child: widget.iconWidget),
          ),
        ),
    );
  }
}
