import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '../../widgets/text_form_field.dart';
import '/widgets/secondary_button.dart';
import '/widgets/dialogs.dart';

class VideoPresentationServiceTestButtons extends StatefulWidget {
  const VideoPresentationServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<VideoPresentationServiceTestButtons> createState() =>
      _VideoPresentationServiceTestButtonsState();
}

class _VideoPresentationServiceTestButtonsState
    extends State<VideoPresentationServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool isDialogCanceled = false;
  TextEditingController urlTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _eventListeners = <StreamSubscription<dynamic>>{};

  @override
  void initState() {
    super.initState();
    _eventListeners.add(_dolbyioCommsSdkFlutterPlugin.videoPresentation
        .onVideoPresentationChange()
        .listen((event) {
      if (event.type == VideoPresentationEventNames.videoPresentationStarted) {
        showResultDialog(
            context, 'VideoPresentationStarted', 'On Event Change');
      } else if (event.type ==
          VideoPresentationEventNames.videoPresentationPaused) {
        showResultDialog(context, 'VideoPresentationPaused', 'On Event Change');
      } else if (event.type ==
          VideoPresentationEventNames.videoPresentationPlayed) {
        showResultDialog(context, 'VideoPresentationPlayed', 'On Event Change');
      } else if (event.type ==
          VideoPresentationEventNames.videoPresentationSought) {
        showResultDialog(context, 'VideoPresentationSought', 'On Event Change');
      }
    }));

    _eventListeners.add(_dolbyioCommsSdkFlutterPlugin.videoPresentation
        .onVideoPresentationStopped()
        .listen((event) {
      showResultDialog(context, 'VideoPresentationStopped', 'On Event Change');
    }));
  }

  @override
  void dispose() {
    for (final element in _eventListeners) {
      element.cancel();
    }
    _eventListeners.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(text: 'Start presenting', onPressed: () => start()),
        SecondaryButton(text: 'Check state', onPressed: () => state()),
        SecondaryButton(text: 'Current video', onPressed: () => currentVideo()),
        SecondaryButton(text: 'Play video', onPressed: () => play()),
        SecondaryButton(text: 'Pause video', onPressed: () => pause()),
        SecondaryButton(text: 'Seek video', onPressed: () => seek()),
        SecondaryButton(text: 'Stop presenting', onPressed: () => stop()),
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

  Future<void> showInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter url'),
            content: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: InputTextFormField(
                labelText: "Url",
                controller: urlTextController,
                focusColor: Colors.deepPurple,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    isDialogCanceled = true;
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  final isValidForm = formKey.currentState!.validate();
                  if (isValidForm) {
                    setState(() => Navigator.pop(context));
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> start() async {
    try {
      await showInputDialog(context);
      if (!isDialogCanceled) {
        _dolbyioCommsSdkFlutterPlugin.videoPresentation
            .start(urlTextController.text);
        if (!mounted) return;
        showResultDialog(context, 'Success', 'OK');
      }
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    } finally {
      isDialogCanceled = false;
    }
  }

  Future<void> state() async {
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

  Future<void> stop() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation.stop();
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> play() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation.play();
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
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
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> seek() async {
    try {
      var currentVideo =
          await _dolbyioCommsSdkFlutterPlugin.videoPresentation.currentVideo();
      await _dolbyioCommsSdkFlutterPlugin.videoPresentation
          .seek(currentVideo!.timestamp);
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
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
