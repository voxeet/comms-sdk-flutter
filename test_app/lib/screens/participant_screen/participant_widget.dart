import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'remote_participant_options.dart';

class ParticipantWidget extends StatelessWidget {
  final Participant participant;
  final bool remoteOptionsFlag;

  const ParticipantWidget(
      {Key? key, required this.participant, required this.remoteOptionsFlag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: VideoView.withMediaStream(
            participant: participant,
            mediaStream: participant.streams?.firstWhereOrNull(
              (s) => s.type == MediaStreamType.camera,
            ),
            scaleType: ScaleType.fill,
            key: ValueKey('video_view_tile_${participant.id}'),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                      '${getParticipantName()}\n${getParticipantStatus()!}',
                      style: const TextStyle(color: Colors.white)),
                ),
                if (remoteOptionsFlag)
                  RemoteParticipantOptions(participant: participant),
              ],
            ),
          ),
        )
      ],
    );
  }

  String getParticipantName() {
    String participantName = participant.info?.name ?? "";
    return participantName;
  }

  String? getParticipantStatus() {
    String? participantStatus = participant.status?.encode();
    return participantStatus;
  }
}
