import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter/src/mapper/mapper.dart';

import '../../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../../dolbyio_comms_sdk_native_events.dart';

/// The AudioPreview model allows the local participant to test different capture modes and voice fonts before a conference. The model is supported only in SDK 3.10 and later.
class AudioPreview {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
    "audio_preview",
  );

  /// @internal
  final _eventStream =
      DolbyioCommsSdkNativeEvents.createEventChannel("audio_preview")
          .receiveBroadcastStream();

  /// Gets the recording status.
  Future<RecorderStatus> status() async {
    var status = await _methodChannel.invokeMethod("status");
    return Future(() => RecorderStatus.decode(status));
  }

  /// Gets an audio capture mode for the audio preview.
  Future<AudioCaptureOptions> getCaptureMode() async {
    var result = await _methodChannel.invokeMethod("getCaptureMode");
    return AudioCaptureOptionsMapper.fromMap(result);
  }

  /// Sets an audio capture mode for the audio preview.
  /// [captureMode] - a capture mode to test
  Future<void> setCaptureMode(AudioCaptureOptions captureMode) async {
    return await _methodChannel.invokeMethod(
        "setCaptureMode", captureMode.toJson());
  }

  /// Plays back the recorded audio sample. To test how your audio sounds while using different capture modes and voice fonts, set the captureMode to a preferred setting before using the method.
  /// [loop] A boolean that indicates wether the SDK should play the recorded audio in a loop.
  Future<void> play(bool loop) async {
    return await _methodChannel.invokeMethod("play", {"loop": loop});
  }

  /// Starts recording an audio sample if no recording is in progress.
  /// [duration] - The preferred recording duration, in seconds.
  Future<void> record(int duration) async {
    return await _methodChannel.invokeMethod("record", {"duration": duration});
  }

  /// Cancels recording or playing an audio sample.
  Future<bool> cancel() async {
    return await _methodChannel.invokeMethod("cancel");
  }

  /// Release the internal memory and restart the audio session configuration.
  Future<void> release() async {
    return await _methodChannel.invokeMethod("release");
  }

  /// Returns a [Stream] of the [AudioPreviewEventNames.onStatusChanged] events. By subscribing to the returned stream you will be notified about new conference invitations.
  Stream<Event<AudioPreviewEventNames, RecorderStatus>> onStatusChanged() {
    return _eventStream
        .addListener([AudioPreviewEventNames.onStatusChanged.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = AudioPreviewEventNames.valueOf(event["key"] as String);
      final data = event["body"] as String;
      return Event(key, RecorderStatus.decode(data));
    });
  }
}
