import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/spatial_environment/spatial_values_row.dart';
import 'dialogs.dart';

class SpatialValueDialogContent extends StatelessWidget {
  final TextEditingController _xTextController = TextEditingController();
  final TextEditingController _yTextController = TextEditingController();
  final TextEditingController _zTextController = TextEditingController();

  final BuildContext spatialValueDialogContext;
  final BuildContext resultDialogContext;
  final String spatialValueType;
  final Participant? participant;

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  SpatialValueDialogContent(
      {Key? key,
        required this.spatialValueType,
        this.participant,
        required this.spatialValueDialogContext,
        required this.resultDialogContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SpatialValuesRow(
          xTextController: _xTextController..text = '1.0',
          yTextController: _yTextController..text = '1.0',
          zTextController: _zTextController..text = '1.0'),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              if(spatialValueType == 'Spatial direction') {
                setSpatialDirection(resultDialogContext);
              } else if(spatialValueType == 'Spatial position') {
                setSpatialPosition(resultDialogContext);
              }
              Navigator.of(spatialValueDialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('CANCEL',
                style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              Navigator.of(spatialValueDialogContext).pop();
            },
          )
        ],
      ),
    ]);
  }

  void setSpatialDirection(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialDirection(
        SpatialDirection(
            double.parse(_xTextController.text.toString()),
            double.parse(_yTextController.text.toString()),
            double.parse(_zTextController.text.toString())))
        .then((value) => showResultDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) =>
        showResultDialog(context, 'Error', error.toString()));
  }

  void setSpatialPosition(BuildContext resultDialogContext) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialPosition(
      participant: participant!,
      position: SpatialPosition(
          double.parse(_xTextController.text.toString()),
          double.parse(_yTextController.text.toString()),
          double.parse(_zTextController.text.toString())),
    )
        .then((value) => showResultDialog(resultDialogContext, "Success", "OK"))
        .onError((error, stackTrace) =>
        showResultDialog(resultDialogContext, "Error", error.toString()));
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
