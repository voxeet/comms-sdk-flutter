import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import '/widgets/dialogs.dart';

class CommandServiceTestButtons extends StatefulWidget {
  const CommandServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<CommandServiceTestButtons> createState() =>
      _CommandServiceTestButtonsState();
}

class _CommandServiceTestButtonsState extends State<CommandServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: 'Send message',
      onPressed: () => send(),
      fillWidth: true,
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

  Future<void> send() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.command.send('Test message');
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }
}
