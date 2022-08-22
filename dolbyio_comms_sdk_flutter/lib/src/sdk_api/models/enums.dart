abstract class EnumWithStringValue implements Enum {
  abstract final String value;
}

/// The ComfortNoiseLevel enum gathers the available comfort noise levels.
enum ComfortNoiseLevel {
  /// The default comfort noise level that is based on the device database. The database contains the proper comfort noise levels, individual for all devices.
  Default('default'),

  /// The low comfort noise level.
  Low('low'),

  /// The medium comfort noise level.
  Medium('medium'),

  /// The disabled comfort noise.
  Off('off');

  final String value;

  const ComfortNoiseLevel(this.value);

  static ComfortNoiseLevel valueOf(String? value) {
    return ComfortNoiseLevel.values.firstWhere(
      (element) => element.value == value || element.name == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The FilePresentationServiceEventNames enum gathers events informing about the file presentation status.
///
/// **Note**: This enum is currently supported only on Android devices.
enum FilePresentationServiceEventNames implements EnumWithStringValue {
  /// Emitted when a file is converted.
  FileConverted('EVENT_FILEPRESENTATION_FILE_CONVERTED'),

  /// Emitted when a presenter starts a file presentation.
  FilePresentationStarted('EVENT_FILEPRESENTATION_STARTED'),

  /// Emitted when a presenter ends a file presentation.
  FilePresentationStopped('EVENT_FILEPRESENTATION_STOPPED'),

  /// Emitted when a presenter changes the displayed page of the shared file.
  FilePresentationUpdated('EVENT_FILEPRESENTATION_UPDATED');

  final String value;

  const FilePresentationServiceEventNames(this.value);

  static FilePresentationServiceEventNames valueOf(String? value) {
    return FilePresentationServiceEventNames.values.firstWhere(
      (element) => element.value == value || element.name == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The NotificationServiceEventNames enum gathers the NotificationService events.
///
/// **Note**: This enum is currently supported only on Android devices.
enum NotificationServiceEventNames implements EnumWithStringValue {
  /// Emitted when an application user receives an invitation.
  InvitationReceived('EVENT_NOTIFICATION_INVITATION_RECEIVED');

  final String value;

  const NotificationServiceEventNames(this.value);

  static NotificationServiceEventNames valueOf(String? value) {
    return NotificationServiceEventNames.values.firstWhere(
      (element) => element.value == value || element.name == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The CommandServiceEventNames enum gathers the CommandService events.
///
/// **Note**: This enum is currently supported only on Android devices.
enum CommandServiceEventNames implements EnumWithStringValue {
  /// Emitted when a participant receives a message.
  MessageReceived('EVENT_COMMAND_MESSAGE_RECEIVED');

  final String value;

  const CommandServiceEventNames(this.value);

  static CommandServiceEventNames valueOf(String? value) {
    return CommandServiceEventNames.values.firstWhere(
      (element) => element.value == value || element.name == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The VideoPresentationState enum gathers the possible statuses of a video presentation.
///
/// **Note**: This enum is currently supported only on Android devices.
enum VideoPresentationState {
  /// The video presentation is paused.
  PAUSED('paused'),

  /// The video presentation is played.
  PLAY('play'),

  /// The video presentation is stopped.
  STOPPED('stopped');

  final String value;

  const VideoPresentationState(this.value);

  static VideoPresentationState valueOf(String? value) {
    return VideoPresentationState.values.firstWhere(
      (element) => element.value == value || element.name == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The VideoPresentationEventNames enum gathers the possible statuses of a video presentation.
///
/// **Note**: This enum is currently supported only on Android devices.
enum VideoPresentationEventNames implements EnumWithStringValue {
  /// Emitted when a video presentation is paused.
  VideoPresentationPaused('EVENT_VIDEOPRESENTATION_PAUSED'),

  /// Emitted when a video presentation is resumed.
  VideoPresentationPlayed('EVENT_VIDEOPRESENTATION_PLAYED'),

  /// Emitted when a video presentation is sought.
  VideoPresentationSought('EVENT_VIDEOPRESENTATION_SOUGHT'),

  /// Emitted when a video presentation is started.
  VideoPresentationStarted('EVENT_VIDEOPRESENTATION_STARTED'),

  /// Emitted when a video presentation is stopped.
  VideoPresentationStopped('EVENT_VIDEOPRESENTATION_STOPPED');

  final String value;

  const VideoPresentationEventNames(this.value);

  static VideoPresentationEventNames valueOf(String? value) {
    return VideoPresentationEventNames.values.firstWhere(
      (element) => element.value == value || element.name == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}
