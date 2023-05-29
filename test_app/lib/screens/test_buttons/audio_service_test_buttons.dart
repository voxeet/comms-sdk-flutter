import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import '/widgets/voice_font_dialog_content.dart';
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
            text: 'Set capture mode - standard',
            onPressed: () => setCaptureMode(AudioCaptureMode.standard)),
        SecondaryButton(
            text: 'Set capture mode - unprocessed',
            onPressed: () => setCaptureMode(AudioCaptureMode.unprocessed)),
        SecondaryButton(
            text: 'Set voice font',
            onPressed: () => setVoiceFontDialog(context)),
      ],
    );
  }

  Future<void> _showDialog(
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
      _showDialog(context, 'Success', comfortNoiseLevel.toString());
    } catch (error) {
      if (!mounted) return;
      _showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setComfortNoiseLevel() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
          .setComfortNoiseLevel(ComfortNoiseLevel.medium);
      if (!mounted) return;
      _showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      _showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> startLocalAudio() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.start();
      if (!mounted) return;
      _showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      _showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopLocalAudio() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio.stop();
      if (!mounted) return;
      _showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      _showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> getCaptureMode() async {
    try {
      final audioCaptureOptions = await _dolbyioCommsSdkFlutterPlugin
          .audioService.localAudio
          .getCaptureMode();
      if (!mounted) return;
      _showDialog(context, 'Success', audioCaptureOptions.toJson().toString());
    } catch (error) {
      if (!mounted) return;
      _showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setCaptureMode(AudioCaptureMode mode) async {
    try {
      var noiseReduction = NoiseReduction.high;
      var options = AudioCaptureOptions(mode, noiseReduction);
      await _dolbyioCommsSdkFlutterPlugin.audioService.localAudio
          .setCaptureMode(options);
      if (!mounted) return;
      _showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      _showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setVoiceFontDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Set Capture mode'),
          content: VoiceFontDialogContent()
        );
      },
    );
  }
}
