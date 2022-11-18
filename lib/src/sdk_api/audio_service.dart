import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/audio/local_audio.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/audio/remote_audio.dart';

/// The AudioService allows changing audio settings for the local and remote participants.
///
/// This service is available in SDK 3.7 and later.
/// {@category Services}
class AudioService {
  /// Audio settings for the local participant.
  final LocalAudio localAudio = LocalAudio();

  /// Audio settings for remote participants.
  final RemoteAudio remoteAudio = RemoteAudio();
}
