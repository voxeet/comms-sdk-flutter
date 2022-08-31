import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import '/widgets/dialogs.dart';

class MediaDeviceServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  MediaDeviceServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(text: 'Get comfort noise level', onPressed: () => getComfortNoiseLevel(context)),
        SecondaryButton(text: 'Set comfort noise level', onPressed: () => setComfortNoiseLevel(context)),
        SecondaryButton(text: 'Is front camera', onPressed: () => isFrontCamera(context)),
        SecondaryButton(text: 'Switch camera', onPressed: () => switchCamera(context)),
      ],
    );
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void getComfortNoiseLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice
        .getComfortNoiseLevel()
        .then((comfortNoiseLevel) => showDialog(context, "Success", comfortNoiseLevel.value))
        .onError((error, stackTrace) => showDialog(context, "Error", error.toString()));
  }

  void setComfortNoiseLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Medium)
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) => showDialog(context, "Error", error.toString()));
  }

  void isFrontCamera(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice
        .isFrontCamera()
        .then((isFrontCamera) => showDialog(context, "Success", isFrontCamera.toString()))
        .onError((error, stackTrace) => showDialog(context, "Error", error.toString()));
  }

  void switchCamera(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice
        .switchCamera()
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) => showDialog(context, "Error", error.toString()));
  }
}
