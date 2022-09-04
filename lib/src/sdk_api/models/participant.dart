import 'package:collection/collection.dart';
import 'conference.dart';
import 'participant_info.dart';
import 'streams.dart';

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
    "status": status?.encode(),
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
  Map<String, Object?> toJson() => {"participant": participant.toJson(), "permissions": permissions.map((e) => e.encode()).toList()};
}

/// The ParticipantStatus enum gathers the possible statuses of a conference participant.
enum ParticipantStatus {
  /// The participant has successfully connected to a conference.
  connected('CONNECTED'),

  /// A participant successfully connected to a conference. In the next release, this status will be replaced with a new status.
  onAir('ON_AIR'),

  /// The participant has received a conference invitation and is connecting to the conference.
  connecting('CONNECTING'),

  /// The invited participant has declined a conference invitation. 
  decline('DECLINE'),

  /// A peer connection has failed and the participant cannot connect to a conference.
  error('ERROR'),

  /// The participant did not enable audio, video, or screen-share and is not connected to any stream.
  inactive('INACTIVE'),

  /// The participant has been kicked out of a conference.
  kicked('KICKED'),

  /// The participant has left a conference.
  left('LEFT'),

  /// The participant has been invited to a conference and is waiting for an invitation.
  reserved('RESERVED'),

  /// The participant has encountered a peer connection problem that may result in the Error or Connected status.
  warning('WARNING');

  final String _value;

  const ParticipantStatus(this._value);

  static ParticipantStatus? decode(String? value) {
    return ParticipantStatus.values.firstWhereOrNull((element) => element._value == value);
  }

  String encode() {
    return _value;
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
class ParticipantInvited {
  /// Information about the invited participant.
  ParticipantInfo info;
  /// The participant permissions.
  List<ConferencePermission>? permissions;

  ParticipantInvited(this.info, this.permissions);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {"info": info.toJson(), "permisions": permissions?.map((e) => e.encode()).toList()};
}
