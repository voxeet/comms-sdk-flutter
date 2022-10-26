import 'dart:async';

import '../../../dolbyio_comms_sdk_flutter.dart';
import '../../dolbyio_comms_sdk_flutter_platform_interface.dart';

/// The [RemoteVideo] allows the local participant to locally start and
/// stop remote participants` video streams transmission.
class RemoteVideo {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
    "remote_video",
  );

  /// If the local participant used the stop method to stop receiving video streams from selected remote participants,
  /// the start method allows the participant to start receiving video streams from these participants.
  /// The start method does not impact the video transmission between remote participants and a conference and does not
  /// allow the local participant to force sending remote participants’ streams to the conference or to the local participant.
  ///
  /// The start method requires a few seconds to become effective.
  Future<void> start(Participant participant) async {
    return await _methodChannel.invokeMethod<void>(
      "start",
      participant.toJson(),
    );
  }

  /// Allows the local participant to stop receiving video from specific remote participants.
  /// This method does not impact audio transmission between remote participants and a conference and does not allow the local
  /// participant to stop sending remote participants’ streams to the conference.
  ///
  /// The stop method requires a few seconds to become effective.
  Future<void> stop(Participant participant) async {
    return await _methodChannel.invokeMethod<void>(
      "stop",
      participant.toJson(),
    );
  }
}
