import 'package:flutter/material.dart';

class InputTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final Color focusColor;
  final String? initialValue;

  const InputTextFormField(
      {Key? key,
      required this.labelText,
      required this.controller,
      this.focusColor = Colors.blue,
        this.initialValue})
      : super(key: key);

  @override
  _InputTextFormFieldState createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
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
    return TextFormField(
      initialValue: widget.initialValue,
      focusNode: myFocusNode,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: widget.labelText,
          labelStyle: TextStyle(
              color: myFocusNode.hasFocus ? widget.focusColor : Colors.black
          ),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: widget.focusColor, width: 2),
          ),
          suffixIcon: IconButton(
            onPressed: widget.controller!.clear,
            icon: const Icon(Icons.clear, color: Colors.grey)
          ),
      ),
      validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
      controller: widget.controller,
    );
  }
}
