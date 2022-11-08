import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';

import '/widgets/dialogs.dart';
import '/widgets/secondary_button.dart';

class VideoServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  VideoServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttons = <Widget>[
      SecondaryButton(
          text: 'Start local video', onPressed: () => startLocalVideo(context)),
      SecondaryButton(
          text: 'Stop local video', onPressed: () => stopLocalVideo(context))
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

  void startLocalVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.videoService.localVideo
        .start()
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError(
          (error, stackTrace) => showDialog(context, 'Error', error.toString()),
        );
  }

  void stopLocalVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.videoService.localVideo
        .stop()
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError(
          (error, stackTrace) => showDialog(context, 'Error', error.toString()),
        );
  }
}
