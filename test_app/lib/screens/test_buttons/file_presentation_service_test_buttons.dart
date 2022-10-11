import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/secondary_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/widgets/dialogs.dart';

class FilePresentationServiceTestButtons extends StatefulWidget {
  const FilePresentationServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<FilePresentationServiceTestButtons> createState() =>
      _FilePresentationServiceTestButtonsState();
}

class _FilePresentationServiceTestButtonsState
    extends State<FilePresentationServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  FileConverted? fileConverted;
  int selectedPage = 0;

  final _eventListeners = <StreamSubscription<dynamic>>{};

  @override
  void initState() {
    super.initState();

    _eventListeners.add(_dolbyioCommsSdkFlutterPlugin.filePresentation
        .onFileConverted()
        .listen((event) {
      switch (event.type) {
        case FilePresentationServiceEventNames.fileConverted:
          showDialog(context, "File presentation evet: fileConverted",
              "On Event Change");
          break;
        case FilePresentationServiceEventNames.filePresentationStarted:
        case FilePresentationServiceEventNames.filePresentationStopped:
        case FilePresentationServiceEventNames.filePresentationUpdated:
          break;
      }
    }));

    _eventListeners.add(_dolbyioCommsSdkFlutterPlugin.filePresentation
        .onFilePresentationChange()
        .listen((event) {
      switch (event.type) {
        case FilePresentationServiceEventNames.fileConverted:
          break;
        case FilePresentationServiceEventNames.filePresentationStarted:
          showDialog(context, "File presentation evet: filePresentationStarted",
              "On Event Change");
          break;
        case FilePresentationServiceEventNames.filePresentationStopped:
          showDialog(context, "File presentation evet: filePresentationStopped",
              "On Event Change");
          break;
        case FilePresentationServiceEventNames.filePresentationUpdated:
          showDialog(context, "File presentation evet: filePresentationUpdated",
              "On Event Change");
          break;
      }
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
        SecondaryButton(
            text: 'Convert', onPressed: () => convert(), fillWidth: false),
        SecondaryButton(
            text: 'Start',
            onPressed: () => startFilePresentation(),
            fillWidth: false),
        SecondaryButton(
            text: 'Stop',
            onPressed: () => stopFilePresentation(),
            fillWidth: false),
        SecondaryButton(
            text: 'getCurrent',
            onPressed: () => getCurrent(),
            fillWidth: false),
        SecondaryButton(
            text: 'setPage', onPressed: () => setPage(), fillWidth: false),
        SecondaryButton(
            text: 'getImage', onPressed: () => getImage(), fillWidth: false),
        SecondaryButton(
            text: 'getThumbnail',
            onPressed: () => getThumbnail(),
            fillWidth: false),
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

  void convert() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'ppt', 'pptx', 'pdf'],
    );
    String? path = result?.files.single.path;

    if (path != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .convert(File(path))
          .then((value) {
        fileConverted = value;
        return showDialog(context, 'Success', value.toJson().toString());
      }).onError((error, stackTrace) =>
              showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "File not selected");
    }
  }

  void startFilePresentation() {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .start(fileConverted!)
          .then((value) => showDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) =>
              showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must convert file first!");
    }
  }

  void stopFilePresentation() {
    _dolbyioCommsSdkFlutterPlugin.filePresentation
        .stop()
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, 'Error', error.toString()));
  }

  void getCurrent() {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getCurrent()
          .then((value) =>
              showDialog(context, 'Success', value.toJson().toString()))
          .onError((error, stackTrace) =>
              showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }

  void setPage() {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .setPage(0)
          .then((value) => showDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) =>
              showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }

  void getImage() {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getImage(0)
          .then((value) => showDialog(context, 'Success', value))
          .onError((error, stackTrace) =>
              showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }

  void getThumbnail() {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getThumbnail(0)
          .then((value) => showDialog(context, 'Success', value))
          .onError((error, stackTrace) =>
              showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }
}
