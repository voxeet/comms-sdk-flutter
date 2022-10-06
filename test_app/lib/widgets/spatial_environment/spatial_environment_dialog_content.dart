import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/spatial_environment/spatial_values_row.dart';
import '../dialogs.dart';

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

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  SpatialEnvironmentDialogContent(
      {Key? key,
      required this.environmentDialogContext,
      required this.resultDialogContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Text("Spatial scale: "),
      SpatialValuesRow(
          xTextController: _scaleXTextController..text = '1.0',
          yTextController: _scaleYTextController..text = '1.0',
          zTextController: _scaleZTextController..text = '1.0'),
      const SizedBox(height: 4),
      const Text("Spatial position (forward) :"),
      SpatialValuesRow(
          xTextController: _forwardXTextController..text = '0.0',
          yTextController: _forwardYTextController..text = '0.0',
          zTextController: _forwardZTextController..text = '1.0'),
      const SizedBox(height: 4),
      const Text("Spatial position (up) :"),
      SpatialValuesRow(
          xTextController: _upXTextController..text = '0.0',
          yTextController: _upYTextController..text = '1.0',
          zTextController: _upZTextController..text = '0.0'),
      const SizedBox(height: 4),
      const Text("Spatial position (right) :"),
      SpatialValuesRow(
          xTextController: _rightXTextController..text = '1.0',
          yTextController: _rightYTextController..text = '0.0',
          zTextController: _rightZTextController..text = '0.0'),
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
    _dolbyioCommsSdkFlutterPlugin.conference
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
        .then((value) => showResultDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  Future<void> showResultDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }
}
