import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import '/widgets/dialogs.dart';

class RecordingServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  RecordingServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(
            text: 'Start recording', onPressed: () => startRecording(context)),
        SecondaryButton(
            text: 'Stop recording', onPressed: () => stopRecording(context)),
        SecondaryButton(
            text: 'Current recording',
            onPressed: () => currentRecording(context)),
      ],
    );
  }

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void startRecording(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.recording
        .start()
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, 'Error', error.toString()));
  }

  void stopRecording(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.recording
        .stop()
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, 'Error', error.toString()));
  }

  void currentRecording(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.recording
        .currentRecording()
        .then((recordingInformation) =>
            showDialog(context, 'Success', recordingInformation.toString()))
        .onError((error, stackTrace) =>
            showDialog(context, 'Error', error.toString()));
  }
}
