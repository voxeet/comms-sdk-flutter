import 'package:flutter/material.dart';

class SwitchOption extends StatefulWidget {
  final String title;
  final bool value;
  final void Function(bool)? onChanged;

  const SwitchOption(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  State<SwitchOption> createState() => _SwitchOptionState();
}

class _SwitchOptionState extends State<SwitchOption> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(widget.title),
        activeColor: Colors.deepPurple,
        value: widget.value,
        onChanged: widget.onChanged);
  }
}
