import 'participant.dart';

/// The VideoPresentation class gathers information about a video presentation.
class VideoPresentation {
  /// The participant who started the presentation.
  Participant owner;

  /// The current video presentation timestamp used for seeking and pausing the video.
  num timestamp;

  /// The URL of the presented video file.
  String url;

  VideoPresentation(this.owner, this.timestamp, this.url);
}