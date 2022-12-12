import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import '/widgets/text_form_field.dart';
import '/widgets/dialogs.dart';
import 'dart:developer' as developer;

class NotificationServiceTestButtons extends StatefulWidget {
  const NotificationServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<NotificationServiceTestButtons> createState() =>
      _NotificationServiceTestButtonsState();
}

class _NotificationServiceTestButtonsState
    extends State<NotificationServiceTestButtons> {
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
              labelText: 'name',
              controller: nameTextController,
              focusColor: Colors.deepPurple,
            ),
            const SizedBox(height: 8),
            InputTextFormField(
              labelText: 'externalID',
              controller: externalIdTextController,
              focusColor: Colors.deepPurple,
            ),
            SecondaryButton(
              text: 'Invite',
              onPressed: () => onInviteButtonPressed(),
              fillWidth: true,
            ),
          ],
        ));
  }

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void onInviteButtonPressed() async {
    try {
      final isValidForm = formKey.currentState!.validate();
      if (isValidForm) await invite();
    } catch (e) {
      developer.log('Cannot invite due to error: $e');
    }
  }

  Future<void> invite() async {
    try {
      var conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
      var participants = await getInvitedParticipants();
      await _dolbyioCommsSdkFlutterPlugin.notification
          .invite(conference, participants);
      if (!mounted) return;
      showDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showDialog(context, 'Error', error.toString());
    }
  }

  Future<List<ParticipantInvited>> getInvitedParticipants() async {
    List<ParticipantInvited> participants = [];
    var participantInvited = ParticipantInvited(
        ParticipantInfo(
            nameTextController.text, null, externalIdTextController.text),
        null);
    participants.add(participantInvited);
    return participants;
  }
}
