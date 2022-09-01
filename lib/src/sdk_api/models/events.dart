import 'conference.dart';
import 'file_presentation.dart';
import 'participant.dart';
import 'streams.dart';

typedef FileConvertedType = FileConverted;

enum CommsAPIEventNames {
  TokenRefresh('EVENT_SDK_TOKEN_REFRESH');

  final String _name;

  const CommsAPIEventNames(this._name);
}

class TokenRefresh {}

class CommsAPIEventMap {
  TokenRefresh? tokenRefresh;
}

/// The FileConvertedEventType class gathers information about a converted file.
///
/// **Note**: This class is currently supported only on Android devices.
class FileConvertedEventType {
  /// The object containing properties specific to the event.
  FileConvertedType fileConverted;

  FileConvertedEventType(this.fileConverted);
}

/// The FilePresentationChangedEventType class gathers information about a presented file.
///
/// **Note**: This class is currently supported only on Android devices.
class FilePresentationChangedEventType {
  /// The object containing properties specific to the event.
  FilePresentation filePresentation;

  FilePresentationChangedEventType(this.filePresentation);
}

/// The InvitationReceivedNotificationData class gathers information about a received invitation.
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
class MessageReceivedData {
  /// The received message.
  String message;

  /// The participant who sent the message.
  Participant participant;

  MessageReceivedData(this.message, this.participant);
}

/// ThePermissionsUpdatedData class gathers information about a conference permissions updates.
class PermissionsUpdatedData {
  /// The conference permissions.
  List<ConferencePermission> permissions;

  PermissionsUpdatedData(this.permissions);
}

/// The StreamsChangeData class gathers information about media stream updates.
class StreamsChangeData {
  Participant participant;
  MediaStream mediaStream;
  StreamsChangeData(this.participant, this.mediaStream);
}
