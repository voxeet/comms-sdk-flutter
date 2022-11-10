import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/secondary_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  FileConverted? _fileConverted;
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
          showDialog(context, 'File presentation event: fileConverted',
              'On Event Change');
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
          showDialog(
              context,
              'File presentation event: filePresentationStarted',
              'On Event Change');
          break;
        case FilePresentationServiceEventNames.filePresentationStopped:
          showDialog(
              context,
              'File presentation event: filePresentationStopped',
              'On Event Change');
          break;
        case FilePresentationServiceEventNames.filePresentationUpdated:
          showDialog(
              context,
              'File presentation event: filePresentationUpdated',
              'On Event Change');
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

  Future<void> convert() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'ppt', 'pptx', 'pdf'],
      );
      String? path = result?.files.single.path;

      if (path != null) {
        var fileConverted = await _dolbyioCommsSdkFlutterPlugin.filePresentation
            .convert(File(path));

        _fileConverted = fileConverted;
        if (!mounted) return;
        showDialog(context, 'Success', fileConverted.toJson().toString());
      } else {
        if (!mounted) return;
        showDialog(context, 'File not selected', 'Cannot convert.');
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error: ', error.toString());
    }
  }

  Future<void> startFilePresentation() async {
    try {
      if (_fileConverted != null) {
        await _dolbyioCommsSdkFlutterPlugin.filePresentation
            .start(_fileConverted!);
        if (!mounted) return;
        showDialog(context, 'Success', 'OK');
      } else {
        if (!mounted) return;
        showDialog(context, 'You must convert file first!',
            'Cannot start presentation');
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error: ', error.toString());
    }
  }

  Future<void> stopFilePresentation() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.filePresentation.stop();
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(
          context, 'You must start presentation first!', error.toString());
    }
  }

  Future<void> getCurrent() async {
    try {
      if (_fileConverted != null) {
        var filePresentation =
            await _dolbyioCommsSdkFlutterPlugin.filePresentation.getCurrent();
        if (!mounted) return;
        showDialog(context, 'Success', filePresentation.toJson().toString());
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(
          context, 'You must start presentation first!', error.toString());
    }
  }

  Future<void> setPage() async {
    try {
      if (_fileConverted != null) {
        await _dolbyioCommsSdkFlutterPlugin.filePresentation.setPage(0);
        if (!mounted) return;
        showDialog(context, 'Success', 'OK');
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(
          context, 'You must start presentation first!', error.toString());
    }
  }

  Future<void> getImage() async {
    try {
      if (_fileConverted != null) {
        var value =
            await _dolbyioCommsSdkFlutterPlugin.filePresentation.getImage(0);
        if (!mounted) return;
        showDialog(context, 'Success', value);
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(
          context, 'You must start presentation first!', error.toString());
    }
  }

  Future<void> getThumbnail() async {
    try {
      if (_fileConverted != null) {
        var value = await _dolbyioCommsSdkFlutterPlugin.filePresentation
            .getThumbnail(0);
        if (!mounted) return;
        showDialog(context, 'Success', value);
      }
    } catch (error) {
      if (!mounted) return;
      showDialog(
          context, 'You must start presentation first!', error.toString());
    }
  }
}
