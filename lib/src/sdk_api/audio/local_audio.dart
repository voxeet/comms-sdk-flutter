import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/src/mapper/mapper.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/audio.dart';

import '../../../dolbyio_comms_sdk_flutter.dart';
import '../../dolbyio_comms_sdk_flutter_platform_interface.dart';

/// The [LocalAudio] allows enabling and disabling the local participant's
/// audio as well as setting and checking the capture mode and comfort noise level.
class LocalAudio {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
    "local_audio",
  );

  /// Returns the local participant's audio capture mode in Dolby Voice conferences.
  Future<AudioCaptureOptions> getCaptureMode() async {
    var result = await _methodChannel
            .invokeMethod<Map<Object?, Object?>>("getCaptureMode") ??
        <String, Object?>{};
    return AudioCaptureOptionsMapper.fromMap(result);
  }

  /// Retrieves the comfort noise level setting for output devices in Dolby Voice conferences.
  Future<ComfortNoiseLevel> getComfortNoiseLevel() async {
    return ComfortNoiseLevel.decode(
      await _methodChannel.invokeMethod<String?>("getComfortNoiseLevel"),
    );
  }

  /// Sets the [comfort noise level] for output devices in Dolby Voice conferences.
  Future<void> setComfortNoiseLevel(ComfortNoiseLevel noiseLevel) async {
    return await _methodChannel.invokeMethod<void>(
      "setComfortNoiseLevel",
      {"noiseLevel": noiseLevel.encode()},
    );
  }

  /// Enables the local participant's audio and sends the audio to a conference.
  /// This method is not available for listeners and triggers the UnsupportedError.
  Future<void> start() async {
    return await _methodChannel.invokeMethod<void>("start");
  }

  /// Disables the local participant's audio and stops sending the audio to a conference.
  /// This method is not available for listeners and triggers the UnsupportedError.
  /// The stop method requires a few seconds to become effective.
  Future<void> stop() async {
    return await _methodChannel.invokeMethod<void>("stop");
  }
}
