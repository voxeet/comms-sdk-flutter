import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final Color focusColor;

  const InputTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.focusColor = Colors.deepPurple
  }): super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: myFocusNode,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: widget.labelText,
          labelStyle: TextStyle(
              color: myFocusNode.hasFocus ? widget.focusColor : Colors.black),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: widget.focusColor, width: 2),
          )
      ),
      controller: widget.controller,
    );
  }
}
