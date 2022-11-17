import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';

import '/widgets/dialogs.dart';
import '/widgets/secondary_button.dart';

class AudioServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  AudioServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttons = <Widget>[
      SecondaryButton(
          text: 'Get comfort noise level',
          onPressed: () => getComfortNoiseLevel(context)),
      SecondaryButton(
          text: 'Set comfort noise level',
          onPressed: () => setComfortNoiseLevel(context)),
      SecondaryButton(
          text: 'Start local audio', onPressed: () => startLocalAudio(context)),
      SecondaryButton(
          text: 'Stop local audio', onPressed: () => stopLocalAudio(context)),
      SecondaryButton(
          text: 'Get capture mode', onPressed: () => getCaptureMode(context)),
      SecondaryButton(
          text: 'Set capture mode', onPressed: () => setCaptureMode(context))
    ];
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: buttons,
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

  void getComfortNoiseLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .getComfortNoiseLevel()
        .then((comfortNoiseLevel) =>
            showDialog(context, "Success", comfortNoiseLevel.toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setComfortNoiseLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.medium)
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void startLocalAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .start()
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError(
          (error, stackTrace) => showDialog(context, 'Error', error.toString()),
        );
  }

  void stopLocalAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .stop()
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError(
          (error, stackTrace) => showDialog(context, 'Error', error.toString()),
        );
  }

  void getCaptureMode(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .getCaptureMode()
        .then((audioCaptureOptions) => showDialog(
            context, 'Success', audioCaptureOptions.toJson().toString()))
        .onError((error, stackTrace) =>
            showDialog(context, 'Error', error.toString()));
  }

  void setCaptureMode(BuildContext context) {
    var mode = AudioCaptureMode.standard;
    var noiseReduction = NoiseReduction.high;
    var options = AudioCaptureOptions(mode, noiseReduction);
    _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setCaptureMode(options)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) =>
            showDialog(context, 'Error', error.toString()));
  }
}
