import 'package:flutter/material.dart';

class InputTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final Color focusColor;
  final String? initialValue;
  final void Function()? onStorageIconTap;
  final bool isStorageNeeded;

  const InputTextFormField(
      {Key? key,
      required this.labelText,
      required this.controller,
      this.focusColor = Colors.blue,
      this.initialValue,
      this.onStorageIconTap,
      this.isStorageNeeded = false})
      : super(key: key);

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
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
            color: myFocusNode.hasFocus ? widget.focusColor : Colors.black),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: widget.focusColor, width: 2),
        ),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isStorageNeeded
                ? IconButton(
                    onPressed: widget.onStorageIconTap,
                    icon: const Icon(Icons.storage),
                    color: Colors.grey,
                  )
                : const SizedBox.shrink(),
            IconButton(
              onPressed: widget.controller!.clear,
              icon: const Icon(Icons.clear, color: Colors.grey),
            )
          ],
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
      controller: widget.controller,
    );
  }
}
