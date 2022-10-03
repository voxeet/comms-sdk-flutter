import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/spatial_environment/spatial_values_row.dart';

class SpatialPosiotionDialogContent extends StatefulWidget {
  final Participant participant;
  final BuildContext spatialPositiontDialogContext;
  final BuildContext resultDialogContext;
  const SpatialPosiotionDialogContent(
      {Key? key,
      required this.participant,
      required this.spatialPositiontDialogContext,
      required this.resultDialogContext})
      : super(key: key);

  @override
  State<SpatialPosiotionDialogContent> createState() =>
      SpatialPosiotionDialogContentState();
}

class SpatialPosiotionDialogContentState
    extends State<SpatialPosiotionDialogContent> {
  final formKeyX = GlobalKey<FormState>();
  final formKeyY = GlobalKey<FormState>();
  final formKeyZ = GlobalKey<FormState>();
  TextEditingController xTextController = TextEditingController();
  TextEditingController yTextController = TextEditingController();
  TextEditingController zTextController = TextEditingController();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SpatialValuesRow(
          xTextController: xTextController..text = '0.0',
          yTextController: yTextController..text = '0.0',
          zTextController: zTextController..text = '0.0'),
      ElevatedButton(
          onPressed: () {
            setSpatialPosition(widget.resultDialogContext);
            Navigator.of(widget.spatialPositiontDialogContext).pop();
          },
          style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          child: const Text("Set")),
      ElevatedButton(
          onPressed: () {
            Navigator.of(widget.spatialPositiontDialogContext).pop();
          },
          style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
          child: const Text("Cancel")),
    ]);
  }

  void setSpatialPosition(BuildContext resultDialogContext) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialPosition(
          participant: widget.participant,
          position: SpatialPosition(
              double.parse(xTextController.text),
              double.parse(yTextController.text),
              double.parse(zTextController.text)),
        )
        .then((value) => showDialog(resultDialogContext, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(resultDialogContext, "Error", error.toString()));
  }

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }
}
