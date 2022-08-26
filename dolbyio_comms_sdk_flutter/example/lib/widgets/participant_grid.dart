import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/participant_widget.dart';

class ParticipantGrid extends StatefulWidget {
  List<Participant> participants;
  ParticipantGrid({Key? key, required this.participants}) : super(key: key);

  @override
  State<ParticipantGrid> createState() => _ParticipantGridState();
}

class _ParticipantGridState extends State<ParticipantGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
            itemCount: widget.participants.length,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12
            ),
            itemBuilder: (context, index) {
              var participant = widget.participants[index];
              return ParticipantWidget(
                  participant: participant,
                  participantIndex: index
              );
            }),
      ),
    );
  }
}
