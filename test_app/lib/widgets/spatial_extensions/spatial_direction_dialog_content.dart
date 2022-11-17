import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../dialogs.dart';
import 'spatial_values_model.dart';
import 'spatial_values_row.dart';

class SpatialDirectionDialogContent extends StatelessWidget {
  final TextEditingController _xTextController = TextEditingController();
  final TextEditingController _yTextController = TextEditingController();
  final TextEditingController _zTextController = TextEditingController();

  final BuildContext spatialValueDialogContext;
  final BuildContext resultDialogContext;
  final Participant? participant;
  final SpatialDirection spatialDirection;

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  SpatialDirectionDialogContent(
      {Key? key,
        this.participant,
        required this.spatialValueDialogContext,
        required this.resultDialogContext,
        required this.spatialDirection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SpatialValuesRow(
          xTextController: _xTextController..text = spatialDirection.x.toString(),
          yTextController: _yTextController..text = spatialDirection.y.toString(),
          zTextController: _zTextController..text = spatialDirection.z.toString()),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.deepPurple)),
            onPressed: () {
              setSpatialDirection(resultDialogContext);
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

  void setSpatialDirection(BuildContext context) async {
    await _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialDirection(
        SpatialDirection(
            double.parse(_xTextController.text.toString()),
            double.parse(_yTextController.text.toString()),
            double.parse(_zTextController.text.toString())))
        .then((value) => showResultDialog(context, 'Success', 'OK', true))
        .onError((error, stackTrace) =>
        showResultDialog(context, 'Error', error.toString(), false));
  }

  Future<void> showResultDialog(
      BuildContext context, String title, String text, bool isSuccess) async {
    if(isSuccess) {
      Provider.of<SpatialValuesModel>(context, listen: false).updateLocalSpatialDirection(
          SpatialDirection(
              double.parse(_xTextController.text.toString()),
              double.parse(_yTextController.text.toString()),
              double.parse(_zTextController.text.toString()))
      );
    }
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }
}
