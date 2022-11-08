import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/audio/local_audio.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/audio/remote_audio.dart';

/// The AudioService allows changing audio settings for the local and remote participants.
class AudioService {
  final LocalAudio localAudio = LocalAudio();

  final RemoteAudio remoteAudio = RemoteAudio();
}
