import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import '/widgets/dialogs.dart';

class CommandServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  CommandServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(text: 'Send message', onPressed: () => send(context));
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void send(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.command
        .send("Test message")
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }
}
