import 'dart:async';

import '../../dolbyio_comms_sdk_flutter_platform_interface.dart';

/// The LocalVideo class allows enabling and disabling the local participant's video.
///
/// This service is available in SDK 3.7 and later.
/// {@category Models}
class LocalVideo {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
    "local_video",
  );

  /// Enables the local participant's video and sends the video to a conference.
  Future<void> start() async {
    return await _methodChannel.invokeMethod<void>("start");
  }

  /// Disables the local participant's video and stops sending the video to a conference.
  /// Use this method only when the current participant is at the conference.
  Future<void> stop() async {
    return await _methodChannel.invokeMethod<void>("stop");
  }
}
