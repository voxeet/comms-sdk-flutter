import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import '/widgets/dialogs.dart';

class VideoPresentationServiceTestButtons extends StatefulWidget {
  const VideoPresentationServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<VideoPresentationServiceTestButtons> createState() => _VideoPresentationServiceTestButtonsState();
}

class _VideoPresentationServiceTestButtonsState extends State<VideoPresentationServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  String url = '';

  @override
  void initState() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation.onVideoPresentationChange()
        .listen((event) {
      if(event.type == VideoPresentationEventNames.videoPresentationStarted) {
        showAlertDialog(context, "VideoPresentationStarted", "On Event Change");
      }
      else if(event.type == VideoPresentationEventNames.videoPresentationPaused) {
        showAlertDialog(context, "VideoPresentationPaused", "On Event Change");
      }
      else if(event.type == VideoPresentationEventNames.videoPresentationPlayed) {
        showAlertDialog(context, "VideoPresentationPlayed", "On Event Change");
      }
      else if(event.type == VideoPresentationEventNames.videoPresentationSought) {
        showAlertDialog(context, "VideoPresentationSought", "On Event Change");
      }
    });

    _dolbyioCommsSdkFlutterPlugin.videoPresentation.onVideoPresentationStopped()
    .listen((event) {
      showAlertDialog(context, "VideoPresentationStopped", "On Event Change");
    });

    super.initState();
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

  Future<void> showAlertDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  Future<void> showInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter url'),
            content: TextField(
              onChanged: (value) { setState(() => url = value); },
              decoration: const InputDecoration(hintText: "Url"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () { setState(() => Navigator.pop(context)); },
              ),
              TextButton(
                child: const Text('Done'),
                onPressed: () { setState(() => Navigator.pop(context)); },
              ),
            ],
          );
        }
    );
  }

  void start() async {
    await showInputDialog(context);
    if(url.isNotEmpty) {
      _dolbyioCommsSdkFlutterPlugin.videoPresentation
          .start(url)
          .then((value) => showAlertDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
    }
  }

  void state() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation
        .state()
        .then((state) => showAlertDialog(context, 'Success', state.name))
        .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
  }

  void stop() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation
        .stop()
        .then((value) => showAlertDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
  }

  void play() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation
        .play()
        .then((value) => showAlertDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
  }

  void pause() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation.currentVideo()
        .then((video) {
      _dolbyioCommsSdkFlutterPlugin.videoPresentation
          .pause(video!.timestamp)
          .then((value) => showAlertDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
        })
        .onError((error, stackTrace) { showAlertDialog(context, 'Error', error.toString()); });
  }

  void seek() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation.currentVideo()
        .then((video) {
      _dolbyioCommsSdkFlutterPlugin.videoPresentation
          .seek(video!.timestamp)
          .then((value) => showAlertDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
        })
        .onError((error, stackTrace) { showAlertDialog(context, 'Error', error.toString()); });
  }

  void currentVideo() {
    _dolbyioCommsSdkFlutterPlugin.videoPresentation
        .currentVideo()
        .then((value) => showAlertDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showAlertDialog(context, 'Error', error.toString()));
  }
}
