// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

/// The RecordingInformation class gathers information about a conference recording.
class RecordingInformation {
  /// The ID of the participant who started the recording.
  String participantId;

  /// The timestamp that informs when the recording was started.
  num startTimestamp;

  /// The recording status that informs whether recording is ongoing.
  RecordingStatus? recordingStatus;

  RecordingInformation(this.participantId, this.startTimestamp, this.recordingStatus);
}

/// The RecordingStatus enum gathers the possible statuses of recording.
enum RecordingStatus {
  /// The conference is recorded.
  RECORDING('RECORDING'),

  /// The conference is not recorded.
  NOT_RECORDING('NOT_RECORDING');

  final String name;

  const RecordingStatus(this.name);

  static RecordingStatus? valueOf(String? value) {
    return RecordingStatus.values.firstWhereOrNull((element) => element.name == value);
  }
}
