import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';

class MockModels {
  static Participant participant(
      [String? id,
      ParticipantInfo? info,
      ParticipantStatus? status,
      ParticipantType? type]) {
    return Participant(id ?? "participantId", info, status, type);
  }
}
