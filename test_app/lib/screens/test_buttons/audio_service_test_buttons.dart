import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import '/widgets/dialogs.dart';
import '/widgets/secondary_button.dart';

class AudioServiceTestButtons extends StatefulWidget {
  const AudioServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<AudioServiceTestButtons> createState() =>
      _AudioServiceTestButtonsState();
}

class _AudioServiceTestButtonsState extends State<AudioServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(
            text: 'Get comfort noise level',
            onPressed: () => getComfortNoiseLevel()),
        SecondaryButton(
            text: 'Set comfort noise level',
            onPressed: () => setComfortNoiseLevel()),
        SecondaryButton(
            text: 'Start local audio', onPressed: () => startLocalAudio()),
        SecondaryButton(
            text: 'Stop local audio', onPressed: () => stopLocalAudio()),
        SecondaryButton(
            text: 'Get capture mode', onPressed: () => getCaptureMode()),
        SecondaryButton(
            text: 'Set capture mode', onPressed: () => setCaptureMode())
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

  Future<void> getComfortNoiseLevel() async {
    try {
      var comfortNoiseLevel = await _dolbyioCommsSdkFlutterPlugin
          .audioService.localAudio
          .getComfortNoiseLevel();
      if (!mounted) return;
      showDialog(context, 'Success', comfortNoiseLevel.toString());
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setComfortNoiseLevel() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
          .setComfortNoiseLevel(ComfortNoiseLevel.medium);
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> startLocalAudio() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.start();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopLocalAudio() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.stop();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> getCaptureMode() async {
    try {
      final audioCaptureOptions = await _dolbyioCommsSdkFlutterPlugin
          .audioService.localAudio
          .getCaptureMode();
      if (!mounted) return;
      showDialog(context, 'Success', audioCaptureOptions.toJson().toString());
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setCaptureMode() async {
    try {
      var mode = AudioCaptureMode.standard;
      var noiseReduction = NoiseReduction.low;
      var options = AudioCaptureOptions(mode, noiseReduction);
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
          .setCaptureMode(options);
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }
}
