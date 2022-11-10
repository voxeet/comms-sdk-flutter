import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpatialValueTextField extends StatelessWidget {
  final String spatialHint;
  final TextEditingController valueTextController;

  const SpatialValueTextField(
      {Key? key, required this.spatialHint, required this.valueTextController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 40,
        child: TextFormField(
            controller: valueTextController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: spatialHint),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ]));
  }
}
