import 'package:flutter/material.dart';
import 'spatial_value_text_field.dart';

class SpatialValuesRow extends StatelessWidget {
  final TextEditingController xTextController;
  final TextEditingController yTextController;
  final TextEditingController zTextController;

  const SpatialValuesRow(
      {Key? key,
      required this.xTextController,
      required this.yTextController,
      required this.zTextController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("x: ", style: TextStyle(fontWeight: FontWeight.bold)),
          SpatialValueTextField(
              spatialHint: "x", valueTextController: xTextController),
          const Text("y: ", style: TextStyle(fontWeight: FontWeight.bold)),
          SpatialValueTextField(
              spatialHint: "y", valueTextController: yTextController),
          const Text("z: ", style: TextStyle(fontWeight: FontWeight.bold)),
          SpatialValueTextField(
              spatialHint: "z", valueTextController: zTextController)
        ]);
  }
}
