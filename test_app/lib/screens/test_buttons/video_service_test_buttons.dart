import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import '/widgets/dialogs.dart';
import '/widgets/secondary_button.dart';

class VideoServiceTestButtons extends StatefulWidget {
  const VideoServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<VideoServiceTestButtons> createState() =>
      _VideoServiceTestButtonsState();
}

class _VideoServiceTestButtonsState extends State<VideoServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(
          text: 'Start local video',
          onPressed: () => startLocalVideo(),
        ),
        SecondaryButton(
          text: 'Stop local video',
          onPressed: () => stopLocalVideo(),
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

  Future<void> startLocalVideo() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoService.localVideo.start();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopLocalVideo() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoService.localVideo.stop();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }
}
