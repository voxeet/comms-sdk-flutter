import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/video/local_video.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/video/remote_video.dart';

/// The VideoService allows changing video settings for the local and remote participants.
///
/// This service is available in SDK 3.7 and later.
/// {@category Services}
class VideoService {
  /// Video settings for the local participant.
  final LocalVideo localVideo = LocalVideo();

  /// Video settings for remote participants.
  final RemoteVideo remoteVideo = RemoteVideo();
}
