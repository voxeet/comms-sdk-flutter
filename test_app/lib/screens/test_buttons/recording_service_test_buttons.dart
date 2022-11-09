import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import '/widgets/dialogs.dart';

class RecordingServiceTestButtons extends StatefulWidget {
  const RecordingServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<RecordingServiceTestButtons> createState() =>
      _RecordingServiceTestButtonsState();
}

class _RecordingServiceTestButtonsState
    extends State<RecordingServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(
          text: 'Start recording',
          onPressed: () => startRecording(),
        ),
        SecondaryButton(
          text: 'Stop recording',
          onPressed: () => stopRecording(),
        ),
        SecondaryButton(
          text: 'Current recording',
          onPressed: () => currentRecording(),
        ),
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

  Future<void> startRecording() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.recording.start();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.recording.stop();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> currentRecording() async {
    try {
      var currentRecording =
          await _dolbyioCommsSdkFlutterPlugin.recording.currentRecording();
      if (!mounted) return;
      showDialog(
          context,
          'Success',
          'Recording status: ${currentRecording.recordingStatus} '
              ', by: ${currentRecording.participantId} '
              ', start time stamp: ${currentRecording.startTimestamp}');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }
}
