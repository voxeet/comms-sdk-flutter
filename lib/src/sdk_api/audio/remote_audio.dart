import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/src/mapper/mapper.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/audio.dart';

import '../../../dolbyio_comms_sdk_flutter.dart';
import '../../dolbyio_comms_sdk_flutter_platform_interface.dart';

/// The [RemoteAudio] allows the local participant to locally mute and unmute remote participants.
class RemoteAudio {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
    "remote_audio",
  );

  /// Enables the local participant's video and sends the video to a conference.
  /// Rejection may be caused by the PromisePermissionRefusedEventException or MediaException.
  /// If the application does not have a permission to start a video stream, it emits PermissionRefusedEvent.
  Future<void> start(Participant participant) async {
    return await _methodChannel.invokeMethod<void>(
      "start",
      participant.toJson(),
    );
  }

  /// Disables the local participant's video and stops sending the video to a conference.
  /// Use this method only when the current participant is at the conference.
  /// Otherwise, the application emits an exception in the catch block of the promise.
  Future<void> stop(Participant participant) async {
    return await _methodChannel.invokeMethod<void>(
      "stop",
      participant.toJson(),
    );
  }
}
