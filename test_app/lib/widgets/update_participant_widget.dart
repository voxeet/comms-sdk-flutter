import 'package:flutter/material.dart';

class UpdateParticipantWidget extends StatefulWidget {
  final void Function(String, String) onUpdateConfirm;
  final void Function() onCancel;

  const UpdateParticipantWidget(
      {super.key, required this.onUpdateConfirm, required this.onCancel});

  @override
  State<StatefulWidget> createState() {
    return UpdateParticipantState();
  }
}

class UpdateParticipantState extends State<UpdateParticipantWidget> {
  var nameTextController = TextEditingController();
  var avatarUrlTextController = TextEditingController();
  late void Function(String, String) onUpdateConfirm;
  late void Function() onCancel;

  @override
  void initState() {
    super.initState();
    onUpdateConfirm = widget.onUpdateConfirm;
    onCancel = widget.onCancel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Participant name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        TextFormField(
          controller: nameTextController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(hintText: "put participant name"),
          keyboardType: TextInputType.name,
        ),
        const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text("Avatar url",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
        TextFormField(
          controller: avatarUrlTextController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(hintText: "put participant name"),
          keyboardType: TextInputType.name,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                var participantName = nameTextController.text;
                var avatarUrl = avatarUrlTextController.text;
                onUpdateConfirm(participantName, avatarUrl);
              },
            ),
            TextButton(
              child: const Text('CANCEL',
                  style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                onCancel.call();
              },
            )
          ],
        )
      ],
    );
  }
}
