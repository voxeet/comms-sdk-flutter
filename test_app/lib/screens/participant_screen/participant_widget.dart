import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'remote_participant_options.dart';

class ParticipantWidget extends StatelessWidget {
  final Participant participant;
  final int participantIndex;

  const ParticipantWidget(
      {Key? key, required this.participant, required this.participantIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 5,
            child: VideoView.withMediaStream(
              participant: participant, 
              mediaStream:participant.streams?.firstWhereOrNull(
                (s) => s.type == MediaStreamType.camera
              ),
              key: ValueKey('video_view_tile_${participant.id}')
            )
        ),
        Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(12))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                          '${getParticipantName()}: ${getParticipantStatus()!}',
                          style: const TextStyle(color: Colors.white))
                  ),
                  if (participantIndex != 0) RemoteParticipantOptions(index: participantIndex),
                ],
              ),
            )
        )
      ],
    );
  }

  String getParticipantName() {
    String participantName = participant.info!.name;
    return participantName;
  }

  String? getParticipantStatus() {
    String? participantStatus = participant.status?.encode();
    return participantStatus;
  }
}
