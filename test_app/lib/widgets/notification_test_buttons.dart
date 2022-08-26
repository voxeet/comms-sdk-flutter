import 'package:dolbyio_comms_sdk_flutter_example/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '../widgets/secondary_button.dart';
import 'dialogs.dart';
import 'dart:developer' as developer;

class NotificationTestButtons extends StatefulWidget {
  const NotificationTestButtons({Key? key}) : super(key: key);

  @override
  State<NotificationTestButtons> createState() => _NotificationTestButtonsState();
}

class _NotificationTestButtonsState extends State<NotificationTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController externalIdTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          InputTextFormField(
            labelText: "name",
            controller: nameTextController,
            focusColor: Colors.deepPurple,
          ),
          const SizedBox(height: 8),
          InputTextFormField(
            labelText: "externalID",
            controller: externalIdTextController,
            focusColor: Colors.deepPurple,
          ),
          SecondaryButton(text: 'Invite', onPressed: () => onInviteButtonPressed()),
        ],
      )
    );
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void onInviteButtonPressed() {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      invite();
    } else {
      developer.log('Cannot invite');
    }
  }

  void invite() {
    List<ParticipantInvited> participants = [];
    var participantInvited = ParticipantInvited(ParticipantInfo(nameTextController.text, null, externalIdTextController.text), null);
    participants.add(participantInvited);

    _dolbyioCommsSdkFlutterPlugin.conference.current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.notification
        .invite(conference, participants)
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) => showDialog(context, "Error", error.toString())));
  }
}
