abstract class EnumWithStringValue implements Enum {
  abstract final String value;
}

/// The ComfortNoiseLevel enum gathers the available comfort noise levels.
///
/// {@category Models}
enum ComfortNoiseLevel {
  /// The default comfort noise level that is based on the device database. The database contains the proper comfort noise levels, individual for all devices.
  defaultLevel('default'),

  /// The low comfort noise level.
  low('low'),

  /// The medium comfort noise level.
  medium('medium'),

  /// The disabled comfort noise.
  off('off');

  final String _value;

  const ComfortNoiseLevel(this._value);

  static ComfortNoiseLevel decode(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return ComfortNoiseLevel.values.firstWhere(
      (element) => element._value == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }

  String encode() {
    return _value;
  }
}

/// The FilePresentationServiceEventNames enum gathers events informing about the file presentation status.
///
/// {@category Models}
enum FilePresentationServiceEventNames implements EnumWithStringValue {
  /// Emitted when a file is converted.
  fileConverted('EVENT_FILEPRESENTATION_FILE_CONVERTED'),

  /// Emitted when a presenter starts a file presentation.
  filePresentationStarted('EVENT_FILEPRESENTATION_STARTED'),

  /// Emitted when a presenter ends a file presentation.
  filePresentationStopped('EVENT_FILEPRESENTATION_STOPPED'),

  /// Emitted when a presenter changes the displayed page of the shared file.
  filePresentationUpdated('EVENT_FILEPRESENTATION_UPDATED');

  @override
  final String value;

  const FilePresentationServiceEventNames(this.value);

  static FilePresentationServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return FilePresentationServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The NotificationServiceEventNames enum gathers the NotificationService events.
///
/// {@category Models}
enum NotificationServiceEventNames implements EnumWithStringValue {
  /// Emitted when an application user receives an invitation.
  invitationReceived('EVENT_NOTIFICATION_INVITATION_RECEIVED'),
  conferenceStatus('EVENT_NOTIFICATION_CONFERENCE_STATUS'),
  conferenceCreated('EVENT_NOTIFICATION_CONFERENCE_CREATED'),
  conferenceEnded('EVENT_NOTIFICATION_CONFERENCE_ENDED'),
  activeParticipants('EVENT_NOTIFICATION_ACTIVE_PARTICIPANTS');

  @override
  final String value;

  const NotificationServiceEventNames(this.value);

  static NotificationServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return NotificationServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The CommandServiceEventNames enum gathers the CommandService events.
///
/// {@category Models}
enum CommandServiceEventNames implements EnumWithStringValue {
  /// Emitted when a participant receives a message.
  messageReceived('EVENT_COMMAND_MESSAGE_RECEIVED');

  @override
  final String value;

  const CommandServiceEventNames(this.value);

  static CommandServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return CommandServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The VideoPresentationState enum gathers the possible statuses of a video presentation.
///
/// {@category Models}
enum VideoPresentationState {
  /// The video presentation is paused.
  paused('paused'),

  /// The video presentation is played.
  play('play'),

  /// The video presentation is stopped.
  stopped('stopped');

  final String _value;

  const VideoPresentationState(this._value);

  static VideoPresentationState decode(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return VideoPresentationState.values.firstWhere(
      (element) => element._value.toLowerCase() == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The VideoPresentationEventNames enum gathers the possible statuses of a video presentation.
///
/// {@category Models}
enum VideoPresentationEventNames implements EnumWithStringValue {
  /// Emitted when a video presentation is paused.
  videoPresentationPaused('EVENT_VIDEOPRESENTATION_PAUSED'),

  /// Emitted when a video presentation is resumed.
  videoPresentationPlayed('EVENT_VIDEOPRESENTATION_PLAYED'),

  /// Emitted when a video presentation is sought.
  videoPresentationSought('EVENT_VIDEOPRESENTATION_SOUGHT'),

  /// Emitted when a video presentation is started.
  videoPresentationStarted('EVENT_VIDEOPRESENTATION_STARTED'),

  /// Emitted when a video presentation is stopped.
  videoPresentationStopped('EVENT_VIDEOPRESENTATION_STOPPED');

  @override
  final String value;

  const VideoPresentationEventNames(this.value);

  static VideoPresentationEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return VideoPresentationEventNames.values.firstWhere(
      (element) =>
          element.value == value ||
          element.name.toLowerCase() == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The recording status.
///
/// This service is available in SDK 3.7 and later.
/// {@category Models}
enum RecordingStatus {
  /// The recording is started.
  recordingStarted('RECORDING'),

  /// The recording is stopped.
  recordingStop('NOT_RECORDING');

  final String value;

  const RecordingStatus(this.value);

  static RecordingStatus valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return RecordingStatus.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The RecordingServiceEventNames enum gathers the recording events.
///
/// {@category Models}
enum RecordingServiceEventNames implements EnumWithStringValue {
  /// Emitted when the recording state of the conference is updated from the remote location.
  recordingStatusUpdate('EVENT_RECORDING_STATUS_UPDATED');

  @override
  final String value;

  const RecordingServiceEventNames(this.value);

  static RecordingServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return RecordingServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}
