import 'dart:async';
import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../dolbyio_comms_sdk_native_events.dart';
import '../mapper/mapper.dart';
import 'models/enums.dart';
import 'models/video_presentation.dart';

/// The VideoPresentationService allows sharing videos during a conference. To present a video, a conference participant needs to provide the URL of the video file. We recommend sharing files in the MPEG-4 Part 14 or MP4 video formats.
///
/// **The video presentation workflow:**
///
/// 1. The presenter calls the [start] method to start the video presentation. This method automatically starts playing the shared video file.
///
/// 2. All participants receive the [VideoPresentationEventNames.VideoPresentationStarted] event.
///
/// 3. The presenter can call the [pause] method to pause the shared video. In such a situation, all conference participants receive the [VideoPresentationEventNames.VideoPresentationPaused] event.
///
/// 4. The presenter can call the [play] method to resume the paused video. In this situation, all conference participants receive the [VideoPresentationEventNames.VideoPresentationPlayed] event.
///
/// 5. The presenter can call the [seek] method to navigate to a specific section of the shared video. This method applies the provided timestamp. After calling the seek method, all conference participants receive the [VideoPresentationEventNames.VideoPresentationSought] event and watch the video from the specified timestamp.
///
/// 6. The presenter calls the [stop] method to stop the video presentation.
///
class VideoPresentationService {
  /// @internal */
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("video_presentation_service");

  /// @internal
  late final _nativeEventsReceiver =
      DolbyioCommsSdkNativeEventsReceiver<VideoPresentationEventNames>.forModuleNamed("video_presentation_service");

  /// Returns information about the current video presentation.
  Future<VideoPresentation?> currentVideo() async {
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>("currentVideo");
    return Future.value(result != null ? VideoPresentationMapper.fromMap(result) : null);
  }

  /// Starts a video presentation. The [file] parameter refers to a video file that the local participant would like to share.
  Future<void> start(String url) async {
    await _methodChannel.invokeMethod("start", {"url": url});
    return Future.value();
  }

  /// Stops a video presentation.
  Future<void> stop() async {
    await _methodChannel.invokeMethod("stop");
    return Future.value();
  }

  /// Resumes the paused video.
  Future<void> play() async {
    await _methodChannel.invokeMethod("play");
    return Future.value();
  }

  /// Pauses a video presentation at a certain [timestamp], in milliseconds.
  Future<void> pause(num timestamp) async {
    await _methodChannel.invokeMethod<void>("pause", {"timestamp": timestamp});
    return Future.value();
  }

  /// Allows a presenter to navigate to a specific section of the shared video file.
  /// The [timestamp] parameter refers to the timestamp at which the video should start, in milliseconds.
  Future<void> seek(num timestamp) async {
    await _methodChannel.invokeMethod<void>("seek", {"timestamp": timestamp});
    return Future.value();
  }

  /// Provides the current state of a video presentation.
  Future<VideoPresentationState> state() async {
    var result = await _methodChannel.invokeMethod<String>("state");
    return Future.value(result != null ? VideoPresentationState.decode(result) : null);
  }

  /// Returns a [Stream] of the [VideoPresentationEventNames.VideoPresentationStarted], [VideoPresentationEventNames.VideoPresentationPaused], [VideoPresentationEventNames.VideoPresentationPlayed], and [VideoPresentationEventNames.VideoPresentationSought] events. By subscribing to the returned stream you will be notified about status changes of video presentations.
  Stream<Event<VideoPresentationEventNames, VideoPresentation>> onVideoPresentationChange() {
    var events = [
      VideoPresentationEventNames.VideoPresentationStarted,
      VideoPresentationEventNames.VideoPresentationPaused,
      VideoPresentationEventNames.VideoPresentationPlayed,
      VideoPresentationEventNames.VideoPresentationSought,
    ];
    return _nativeEventsReceiver.addListener(events).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = VideoPresentationEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, VideoPresentationMapper.fromMap(data));
    });
  }
  
  /// Returns a [Stream] of the [VideoPresentationEventNames.VideoPresentationStopped] events. By subscribing to the returned stream you will be notified each time a video presentation ends.
  Stream<Event<VideoPresentationEventNames, void>> onVideoPresentationStopped() {
    return _nativeEventsReceiver.addListener([VideoPresentationEventNames.VideoPresentationStopped]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = VideoPresentationEventNames.valueOf(event["key"] as String);
      return Event(key, null);
    });
  }
}
