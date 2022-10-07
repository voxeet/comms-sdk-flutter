import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/src/mapper/mapper.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/audio.dart';

import '../../../dolbyio_comms_sdk_flutter.dart';
import '../../dolbyio_comms_sdk_flutter_platform_interface.dart';

/// The [LocalVideo] allows enabling and disabling the local participant's video.
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
