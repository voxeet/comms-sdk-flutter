import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../dialogs.dart';
import 'spatial_values_model.dart';
import 'spatial_values_row.dart';

class SpatialEnvironmentDialogContent extends StatelessWidget {
  final TextEditingController _scaleXTextController = TextEditingController();
  final TextEditingController _scaleYTextController = TextEditingController();
  final TextEditingController _scaleZTextController = TextEditingController();
  final TextEditingController _forwardXTextController = TextEditingController();
  final TextEditingController _forwardYTextController = TextEditingController();
  final TextEditingController _forwardZTextController = TextEditingController();
  final TextEditingController _upXTextController = TextEditingController();
  final TextEditingController _upYTextController = TextEditingController();
  final TextEditingController _upZTextController = TextEditingController();
  final TextEditingController _rightXTextController = TextEditingController();
  final TextEditingController _rightYTextController = TextEditingController();
  final TextEditingController _rightZTextController = TextEditingController();

  final BuildContext environmentDialogContext;
  final BuildContext resultDialogContext;
  final SpatialScale spatialScaleForEnvironment;
  final SpatialPosition forwardPositionForEnvironment;
  final SpatialPosition upPositionForEnvironment;
  final SpatialPosition rightPositionForEnvironment;

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  SpatialEnvironmentDialogContent(
      {Key? key,
      required this.environmentDialogContext,
      required this.resultDialogContext,
      required this.spatialScaleForEnvironment,
      required this.forwardPositionForEnvironment,
      required this.upPositionForEnvironment,
      required this.rightPositionForEnvironment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Text("Spatial scale: "),
      SpatialValuesRow(
          xTextController: _scaleXTextController
            ..text = spatialScaleForEnvironment.x.toString(),
          yTextController: _scaleYTextController
            ..text = spatialScaleForEnvironment.y.toString(),
          zTextController: _scaleZTextController
            ..text = spatialScaleForEnvironment.z.toString()),
      const SizedBox(height: 4),
      const Text("Spatial position (forward) :"),
      SpatialValuesRow(
          xTextController: _forwardXTextController
            ..text = forwardPositionForEnvironment.x.toString(),
          yTextController: _forwardYTextController
            ..text = forwardPositionForEnvironment.y.toString(),
          zTextController: _forwardZTextController
            ..text = forwardPositionForEnvironment.z.toString()),
      const SizedBox(height: 4),
      const Text("Spatial position (up) :"),
      SpatialValuesRow(
          xTextController: _upXTextController
            ..text = upPositionForEnvironment.x.toString(),
          yTextController: _upYTextController
            ..text = upPositionForEnvironment.y.toString(),
          zTextController: _upZTextController
            ..text = upPositionForEnvironment.z.toString()),
      const SizedBox(height: 4),
      const Text("Spatial position (right) :"),
      SpatialValuesRow(
          xTextController: _rightXTextController
            ..text = rightPositionForEnvironment.x.toString(),
          yTextController: _rightYTextController
            ..text = rightPositionForEnvironment.y.toString(),
          zTextController: _rightZTextController
            ..text = rightPositionForEnvironment.z.toString()),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              setSpatialEnvironment(resultDialogContext);
              Navigator.of(environmentDialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('CANCEL',
                style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              Navigator.of(environmentDialogContext).pop();
            },
          )
        ],
      ),
    ]);
  }

  void setSpatialEnvironment(BuildContext context) async {
    await _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialEnvironment(
            SpatialScale(
                double.parse(_scaleXTextController.text.toString()),
                double.parse(_scaleYTextController.text.toString()),
                double.parse(_scaleZTextController.text.toString())),
            SpatialPosition(
                double.parse(_forwardXTextController.text.toString()),
                double.parse(_forwardYTextController.text.toString()),
                double.parse(_forwardZTextController.text.toString())),
            SpatialPosition(
                double.parse(_upXTextController.text.toString()),
                double.parse(_upYTextController.text.toString()),
                double.parse(_upZTextController.text.toString())),
            SpatialPosition(
                double.parse(_rightXTextController.text.toString()),
                double.parse(_rightYTextController.text.toString()),
                double.parse(_rightZTextController.text.toString())))
        .then((value) => showResultDialog(context, 'Success', 'OK', true))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString(), false));
  }

  Future<void> showResultDialog(
      BuildContext context, String title, String text, bool flag) async {
    if (flag) {
      Provider.of<SpatialValuesModel>(context, listen: false)
          .updateLocalSpatialEnvironment(
        SpatialScale(
            double.parse(_scaleXTextController.text.toString()),
            double.parse(_scaleYTextController.text.toString()),
            double.parse(_scaleZTextController.text.toString())),
        SpatialPosition(
            double.parse(_forwardXTextController.text.toString()),
            double.parse(_forwardYTextController.text.toString()),
            double.parse(_forwardZTextController.text.toString())),
        SpatialPosition(
            double.parse(_upXTextController.text.toString()),
            double.parse(_upYTextController.text.toString()),
            double.parse(_upZTextController.text.toString())),
        SpatialPosition(
            double.parse(_rightXTextController.text.toString()),
            double.parse(_rightYTextController.text.toString()),
            double.parse(_rightZTextController.text.toString())),
      );
    }
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }
}
