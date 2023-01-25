import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/state_management/models/conference_model.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dialogs.dart';

class VideoPresentationButtons extends StatefulWidget {
  const VideoPresentationButtons({Key? key}) : super(key: key);

  @override
  State<VideoPresentationButtons> createState() =>
      _VideoPresentationButtonsState();
}

class _VideoPresentationButtonsState extends State<VideoPresentationButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => play(),
              icon: const Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () => pause(),
              icon: const Icon(Icons.pause),
            ),
            IconButton(
              onPressed: () => seek(),
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () => stop(),
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
        SecondaryButton(
          text: 'checkVideoState',
          onPressed: () => checkState(),
          color: Colors.black,
        ),
        SecondaryButton(
          text: 'currentVideoPresentation',
          onPressed: () => currentVideo(),
          color: Colors.black,
        ),
      ],
    );
  }

  Future<void> showResultDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  Future<void> play() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation.play();
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> pause() async {
    try {
      var currentVideo =
          await _dolbyioCommsSdkFlutterPlugin.videoPresentation.currentVideo();
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation
          .pause(currentVideo!.timestamp);
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> seek() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation.seek(0);
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stop() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation.stop();
      if (!mounted) return;
      setState(() {
        Provider.of<ConferenceModel>(context, listen: false)
            .isSomeonePresentingVideo = false;
      });
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> checkState() async {
    try {
      var videoPresentationState =
          await _dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
      if (!mounted) return;
      showResultDialog(context, 'Success', videoPresentationState.name);
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> currentVideo() async {
    try {
      var currentVideo =
          await _dolbyioCommsSdkFlutterPlugin.videoPresentation.currentVideo();
      if (!mounted) return;
      showResultDialog(
          context,
          'Success',
          'Current video owner: ${currentVideo?.owner.info?.name}'
              ', url: ${currentVideo?.url}'
              ', timestamp: ${currentVideo?.timestamp}');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }
}
