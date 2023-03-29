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

/// The ConferenceStatusNotificationData class gathers information about a conference status.
///
/// {@category Models}
class ConferenceStatusNotificationData {
  /// The conference alias.
  String? conferenceAlias;

  /// The conference ID.
  String? conferenceId;

  /// Information whether the conference is ongoing.
  bool? live;

  /// The list of the conference participants.
  List<Participant> participants;

  ConferenceStatusNotificationData(
    this.conferenceAlias,
    this.conferenceId,
    this.live,
    this.participants,
  );

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() => {
        "conferenceAlias": conferenceAlias,
        "conferenceId": conferenceId,
        "live": live,
        "participants": participants.map((e) => e.toJson()).toList()
      };
}

/// The ConferenceCreatedNotificationData class gathers information about a conference created.
///
/// {@category Models}
class ConferenceCreatedNotificationData {
  /// The conference alias.
  String conferenceAlias;

  /// The conference ID.
  String conferenceId;

  ConferenceCreatedNotificationData(this.conferenceAlias, this.conferenceId);

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() =>
      {"conferenceAlias": conferenceAlias, "conferenceId": conferenceId};
}

/// The ConferenceEndedNotificationData class gathers information about a conference ended.
///
/// {@category Models}
class ConferenceEndedNotificationData {
  /// The conference alias.
  String conferenceAlias;

  /// The conference ID.
  String conferenceId;

  ConferenceEndedNotificationData(this.conferenceAlias, this.conferenceId);

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() =>
      {"conferenceAlias": conferenceAlias, "conferenceId": conferenceId};
}

/// The ActiveParticipantsNotificationData class gathers information about a active participants.
///
/// {@category Models}
class ActiveParticipantsNotificationData {
  /// The conference alias.
  String conferenceAlias;

  /// The conference ID.
  String conferenceId;

  /// The participant count.
  int participantCount;

  /// The list of active participants.
  List<Participant> participants;

  ActiveParticipantsNotificationData(this.conferenceAlias, this.conferenceId,
      this.participantCount, this.participants);

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() => {
        "conferenceAlias": conferenceAlias,
        "conferenceId": conferenceId,
        "participantCount": participantCount,
        "participants": participants
      };
}

/// The ParticipantJoinedNotificationData class gathers information .
///
/// {@category Models}
class ParticipantJoinedNotificationData {
  /// The conference alias.
  String conferenceAlias;

  /// The conference ID.
  String conferenceId;

  /// The participant who joined the conference.
  Participant participant;

  ParticipantJoinedNotificationData(
      this.conferenceAlias, this.conferenceId, this.participant);

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() => {
        "conferenceAlias": conferenceAlias,
        "conferenceId": conferenceId,
        "participant": participant
      };
}

/// The ParticipantLeftNotificationData class gathers information .
///
/// {@category Models}
class ParticipantLeftNotificationData {
  /// The conference alias.
  String conferenceAlias;

  /// The conference ID.
  String conferenceId;

  /// The participant who left the conference.
  Participant participant;

  ParticipantLeftNotificationData(
      this.conferenceAlias, this.conferenceId, this.participant);

  /// Returns a representation of this object as a JSON object.
  Map<Object?, Object?> toJson() => {
        "conferenceAlias": conferenceAlias,
        "conferenceId": conferenceId,
        "participant": participant
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

/// The PermissionsUpdatedData class gathers information about a conference permissions updates.
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

/// The RecordingStatusUpdate model contains information about recording statuses.
///
/// This service is available in SDK 3.7 and later.
/// {@category Models}
class RecordingStatusUpdate {
  /// The recording status.
  RecordingStatus recordingStatus;

  /// The unique identifier of the conference.
  String? conferenceId;

  /// The unique identifier the participant who changed the recording status.
  String? participantId;

  ///The timestamp of when the recording status changed.
  int? timeStamp;

  RecordingStatusUpdate(this.recordingStatus, this.conferenceId,
      this.participantId, this.timeStamp);

  static RecordingStatusUpdate fromMap(Map<Object?, Object?> data) {
    RecordingStatus recordingStatus =
        RecordingStatus.valueOf(data["recordingStatus"] as String);
    String? conferenceId = data["conferenceId"] as String?;
    String? participantId = data["participantId"] as String?;
    int? timeStamp = data["timeStamp"] as int?;
    return RecordingStatusUpdate(
        recordingStatus, conferenceId, participantId, timeStamp);
  }
}
