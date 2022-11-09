import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import '/widgets/dialogs.dart';
import '/widgets/secondary_button.dart';

class MediaDeviceServiceTestButtons extends StatefulWidget {
  const MediaDeviceServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<MediaDeviceServiceTestButtons> createState() =>
      _MediaDeviceServiceTestButtonsState();
}

class _MediaDeviceServiceTestButtonsState
    extends State<MediaDeviceServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(
          text: 'Get comfort noise level',
          onPressed: () => getComfortNoiseLevel(),
        ),
        SecondaryButton(
          text: 'Set comfort noise level',
          onPressed: () => setComfortNoiseLevel(),
        ),
        SecondaryButton(
          text: 'Is front camera',
          onPressed: () => isFrontCamera(),
        ),
        SecondaryButton(
          text: 'Switch camera',
          onPressed: () => switchCamera(),
        ),
        SecondaryButton(
          text: 'Switch speaker',
          onPressed: () => switchSpeaker(),
        )
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

  Future<void> isFrontCamera() async {
    try {
      var isFrontCamera =
          await _dolbyioCommsSdkFlutterPlugin.mediaDevice.isFrontCamera();
      if (!mounted) return;
      showDialog(context, 'Success', isFrontCamera.toString());
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> switchCamera() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.mediaDevice.switchCamera();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> switchSpeaker() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.mediaDevice.switchSpeaker();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }
}
