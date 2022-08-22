import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';

import '../mapper/mapper.dart';
import 'models/recording.dart';

/// The RecordingService allows recording conferences.
class RecordingService {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("recording_service");

  /// Returns information about the current recording. Use this accessor if you wish to receive information that is available in the Recording object,
  /// such as the ID of the participant who started the recording or the timestamp that informs when the recording was started.
  Future<RecordingInformation?> currentRecording() async {
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>("currentRecording") ?? <String, Object?>{};
    return Future.value(RecordingInformationMapper.fromMap(result));
  }

  /// Starts recording a conference.
  Future<void> start() async {
    await _methodChannel.invokeMethod("start");
    return Future.value();
  }

  /// Stops recording a conference.
  Future<void> stop() async {
    await _methodChannel.invokeMethod("stop");
    return Future.value();
  }
}
