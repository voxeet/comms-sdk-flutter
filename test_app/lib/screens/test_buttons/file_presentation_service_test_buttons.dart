import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/secondary_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/widgets/dialogs.dart';

class FilePresentationServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  FileConverted? fileConverted;
  int selectedPage = 0;

  FilePresentationServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(text: 'Convert', onPressed: () => convert(context), fillWidth: false),
        SecondaryButton(text: 'Start', onPressed: () => startFilePresentation(context), fillWidth: false),
        SecondaryButton(text: 'Stop', onPressed: () => stopFilePresentation(context), fillWidth: false),
        SecondaryButton(text: 'getCurrent', onPressed: () => getCurrent(context), fillWidth: false),
        SecondaryButton(text: 'setPage', onPressed: () => setPage(context), fillWidth: false),
        SecondaryButton(text: 'getImage', onPressed: () => getImage(context), fillWidth: false),
        SecondaryButton(text: 'getThumbnail', onPressed: () => getThumbnail(context), fillWidth: false),
      ],
    );
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void convert(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'ppt', 'pptx', 'pdf'],
    );
    String? path = result?.files.single.path;

    if (path != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation.convert(File(path)).then((value) {
        fileConverted = value;
        return showDialog(context, 'Success', value.toJson().toString());
      }).onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "File not selected");
    }
  }

  void startFilePresentation(BuildContext context) {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .start(fileConverted!)
          .then((value) => showDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must convert file first!");
    }
  }

  void stopFilePresentation(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.filePresentation
        .stop()
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getCurrent(BuildContext context) {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getCurrent()
          .then((value) => showDialog(context, 'Success', value.toJson().toString()))
          .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }

  void setPage(BuildContext context) {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .setPage(0)
          .then((value) => showDialog(context, 'Success', "OK"))
          .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }

  void getImage(BuildContext context) {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getImage(0)
          .then((value) => showDialog(context, 'Success', value))
          .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }

  void getThumbnail(BuildContext context) {
    if (fileConverted != null) {
      _dolbyioCommsSdkFlutterPlugin.filePresentation
          .getThumbnail(0)
          .then((value) => showDialog(context, 'Success', value))
          .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
    } else {
      Fluttertoast.showToast(msg: "You must start presentation first!");
    }
  }
}
