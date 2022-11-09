import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/enums.dart';

import 'conference.dart';
import 'file_presentation.dart';
import 'participant.dart';
import 'streams.dart';

typedef FileConvertedType = FileConverted;

/// The InvitationReceivedNotificationData class gathers information about a received invitation.
///
/// {@category Models}
class InvitationReceivedNotificationData {
  /// The conference alias.
  String conferenceAlias;

  /// The conference ID.
  String conferenceId;

  /// The conference access token.
  String conferenceToken;

  /// The participant who sent the invitation.
  Participant participant;

  InvitationReceivedNotificationData(
    this.conferenceAlias,
    this.conferenceId,
    this.conferenceToken,
    this.participant,
  );

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() => {
        "conferenceAlias": conferenceAlias,
        "conferenceId": conferenceId,
        "conferenceToken": conferenceToken,
        "participant": participant.toJson()
      };
}

/// The MessageReceivedData interface gathers information about a received message.
///
/// {@category Models}
class MessageReceivedData {
  /// The received message.
  String message;

  /// The participant who sent the message.
  Participant participant;

  MessageReceivedData(this.message, this.participant);
}

/// ThePermissionsUpdatedData class gathers information about a conference permissions updates.
///
/// {@category Models}
class PermissionsUpdatedData {
  /// The conference permissions.
  List<ConferencePermission> permissions;

  PermissionsUpdatedData(this.permissions);
}

/// The StreamsChangeData class gathers information about media stream updates.
///
/// {@category Models}
class StreamsChangeData {
  Participant participant;
  MediaStream mediaStream;
  StreamsChangeData(this.participant, this.mediaStream);
}

class RecordingStatusUpdate {
  RecordingStatus recordingStatus;
  String conferenceId;
  String participantId;
  int timeStamp;

  RecordingStatusUpdate(
    this.recordingStatus,
    this.conferenceId,
    this.participantId,
    this.timeStamp
  );

  static RecordingStatusUpdate fromMap(Map<Object?, Object?> data) {
    RecordingStatus recordingStatus =
        RecordingStatus.valueOf(data["recordingStatus"] as String);
    String conferenceId = data["conferenceId"] as String;
    String participantId = data["participantId"] as String;
    int timeStamp = data["timeStamp"] as int;
    return RecordingStatusUpdate(
        recordingStatus,
        conferenceId,
        participantId,
        timeStamp
    );
  }

}
