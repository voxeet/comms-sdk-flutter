import 'package:collection/collection.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/streams.dart';

import 'conference.dart';
import 'participant_info.dart';


/// The Participant class gathers information about a conference participant.
class Participant {
  /// The participant ID.
  String id;

  /// Information about the conference participant.
  ParticipantInfo? info;

  /// The participant status.
  ParticipantStatus? status;

  /// The participant's streams.
  List<MediaStream>? streams;

  /// The participant type.
  ParticipantType? type;

  Participant(this.id, this.info, this.status, this.type);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
    "id": id,
    "info": info?.toJson(),
    "status": status?.value,
    "type": type?.value,
    "streams": streams?.map((e) => e.toJson()).toList()
  };
}

/// The ParticipantPermissions class gathers information about the invited participants and their conference permissions.
class ParticipantPermissions {
  /// The invited participant.
  Participant participant;
  /// The participant permissions.
  List<ConferencePermission> permissions;

  ParticipantPermissions(this.participant, this.permissions);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {"participant": participant.toJson(), "permissions": permissions.map((e) => e.name).toList()};
}

/// The ParticipantStatus enum gathers the possible statuses of a conference participant.
enum ParticipantStatus {
  /// The participant has successfully connected to a conference.
  CONNECTED('CONNECTED'),

  /// A participant successfully connected to a conference. In the next release, this status will be replaced with a new status.
  ON_AIR('ON_AIR'),

  /// The participant has received a conference invitation and is connecting to the conference.
  CONNECTING('CONNECTING'),

  /// The invited participant has declined a conference invitation. 
  DECLINE('DECLINE'),

  /// A peer connection has failed and the participant cannot connect to a conference.
  ERROR('ERROR'),

  /// The participant did not enable audio, video, or screen-share and is not connected to any stream.
  INACTIVE('INACTIVE'),

  /// The participant has been kicked out of a conference.
  KICKED('KICKED'),

  /// The participant has left a conference.
  LEFT('LEFT'),

  /// The participant has been invited to a conference and is waiting for an invitation.
  RESERVED('RESERVED'),

  /// The participant has encountered a peer connection problem that may result in the Error or Connected status.
  WARNING('WARNING');

  final String value;

  const ParticipantStatus(this.value);

  static ParticipantStatus? valueOf(String? value) {
    return ParticipantStatus.values.firstWhereOrNull((element) => element.value == value || element.name == value);
  }
}

/// The ParticipantType enum gathers the possible types of a conference participant.
enum ParticipantType {
  /// A participant who cannot send any audio or video stream to a conference.
  LISTENER("listener"),

  /// A participant who can send and receive audio and video during the conference.
  USER("user"),

  /// A participant whos type is not known.
  UNKNOWN("unknown");

  final String value;

  const ParticipantType(this.value);

  static ParticipantType? valueOf(String? value) {
    return ParticipantType.values.firstWhereOrNull((element) => element.value == value || element.name == value) ?? ParticipantType.UNKNOWN;
  }
}

/// The ParticipantInvited class gathers information about an invited participant.
///
/// **Note**: This class is currently supported only on Android devices.
class ParticipantInvited {
  /// Information about the invited participant.
  ParticipantInfo info;
  /// The participant permissions.
  List<ConferencePermission>? permissions;

  ParticipantInvited(this.info, this.permissions);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {"info": info.toJson(), "permisions": permissions?.map((e) => e.value).toList()};
}
