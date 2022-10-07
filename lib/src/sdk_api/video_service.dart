import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/video/local_video.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/video/remote_video.dart';

/// The VideoService allows changing video settings for the local and remote participants.
class VideoService {
  final LocalVideo localVideo = LocalVideo();

  final RemoteVideo remoteVideo = RemoteVideo();
}
