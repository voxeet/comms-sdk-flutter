import 'package:flutter/material.dart';

class SwitchOption extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(title),
        activeColor: Colors.deepPurple,
        value: value,
        onChanged: onChanged);
  }
}
