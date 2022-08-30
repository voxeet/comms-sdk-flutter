
typedef AudioTrack = Object;
typedef VideoTrack = Object;

/// The MediaStream type gathers information about media streams.
class MediaStream {
  /// The media stream identifier.
  String id;

  /// The media stream type.
  MediaStreamType type;

  /// The audio tracks available in the stream.
  List<AudioTrack> audioTracks;

  /// The video tracks available in the stream.
  List<VideoTrack> videoTracks;

  /// The media stream label.
  String label;

  MediaStream(this.id, this.type, this.audioTracks, this.videoTracks,
      this.label);

  Map<String?, Object?> toJson() =>
      {
        "id": id,
        "type": type.value,
        "audioTracks": audioTracks,
        "videoTracks": videoTracks,
        "label": label
      };
}

/// The MediaStreamType enum gathers the possible types of media streams.
enum MediaStreamType {
  /// The camera media stream, either audio, video, or audio and video. This stream type is enabled by default.
  Camera('CAMERA'),
  /// A media stream produced by an external device.
  Custom('CUSTOM'),
  /// The screen-share media stream.
  ScreenShare('SCREEN_SHARE');

  final String value;

  const MediaStreamType(this.value);

  static MediaStreamType? valueOf(String? value) {
    if (value == null) {
      return null;
    }
    return MediaStreamType.values.firstWhere((element) => element.value == value || element.name == value);

  }
}

