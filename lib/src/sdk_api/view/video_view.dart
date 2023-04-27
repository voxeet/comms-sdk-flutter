import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';

/// A controller for the [VideoView] that is responsible for attaching a [Participant] and a
/// [MediaStream] to the [VideoView], detaching them, and getting information about the
/// [VideoView] state.
///
/// An instance of this class can be provided during the instantiation of the [VideoView] widget,
/// if this widget is constructed using the default constructor.
///
/// {@category Widgets}
class VideoViewController {
  _VideoViewState? _state;

  Participant? _participant;
  MediaStream? _mediaStream;

  VideoViewController();

  /// Attaches a [Participant] and a [MediaStream] to the [VideoView]. This allows the
  /// [VideoView] to display the provided [MediaStream] if the media stream object belongs
  /// to the provided [Participant].
  void attach(Participant participant, MediaStream? mediaStream) {
    _participant = participant;
    _mediaStream = mediaStream;
    _state?._attach(participant, mediaStream);
  }

  /// Detaches a [MediaStream] and a [Participant] from the [VideoView] to stop displaying
  /// the [MediaStream].
  void detach() async {
    _participant = null;
    _mediaStream = null;
    _state?._detach();
  }

  /// Returns true if a [MediaStream] is currently attached to the [VideoView].
  Future<bool> isAttached() async {
    final state = _state;
    if (state != null) {
      return state._isAttached();
    }
    developer.log(
        "VideoViewController.isAttached(): The VideoView has not been instantiated yet.");
    return Future.value(false);
  }

  /// Returns true if the attached [MediaStream] contains a video track whose contents come from a
  /// screen shared by the local participant.
  Future<bool> isScreenShare() async {
    final state = _state;
    if (state != null) {
      return state._isScreenShare();
    }
    developer.log(
        "VideoViewController.isScreenShare(): The VideoView has not been instantiated yet.");
    return Future.error("The VideoView has not been instantiated yet.");
  }

  void _updateState(_VideoViewState? state) {
    _state = state;
  }
}

/// A widget that can display a [MediaStream] for a [Participant].
///
/// You can use [VideoView] in two ways, either as an item of a [GridView] or a [ListView] used
/// with the [VideoView.withMediaStream] constructor or as a stand-alone widget outside of collection
/// widgets, such as [GridView] or [ListView]. In this second option, you need to use the
/// [VideoView] constructor and provide a [VideoViewController] to the constructor.
///
/// {@category Widgets}
class VideoView extends StatefulWidget {
  /// @internal
  final String viewType = 'video_view';

  /// @internal
  final Participant? participant;

  /// @internal
  final MediaStream? mediaStream;

  /// @internal
  final VideoViewController? videoViewController;

  /// A constructor that should be used when the [VideoView] is an element in a collection
  /// widget, such as a [GridView] or a [ListView]. The constructor requires providing the
  /// [Participant] for whom the [MediaStream] should be displayed, the [MediaStream], and an
  /// optional [Key].
  const VideoView.withMediaStream(
      {required this.participant, required this.mediaStream, Key? key})
      : videoViewController = null,
        super(key: key);

  /// A constructor that shuold be used when the [VideoView] is used as a stand-alone widget
  /// outside of collection widgets such as [GridView] or [ListView]. The constructor requires
  /// providing the [VideoViewController] and, optionally, a [Key].
  const VideoView({required this.videoViewController, Key? key})
      : participant = null,
        mediaStream = null,
        super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  static int _viewNumber = 0;
  static int _getNextViewNubmer() {
    _viewNumber += 1;
    return _viewNumber;
  }

  Participant? _participant;
  MediaStream? _mediaStream;
  int viewNumber;
  MethodChannel? _methodChannel;

  _VideoViewState() : viewNumber = _getNextViewNubmer();

  @override
  void initState() {
    widget.videoViewController?._updateState(this);
    _updateParticipantAndStream();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    widget.videoViewController?._updateState(this);
    _updateParticipantAndStream();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.videoViewController?._updateState(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> creationParams = {};

    final participantId = _participant?.id;
    if (participantId != null) {
      creationParams["participant_id"] = participantId;
    }

    final mediaStreamId = _mediaStream?.id;
    if (mediaStreamId != null) {
      creationParams["media_stream_id"] = mediaStreamId;
    }

    final mediaStreamLabel = _mediaStream?.label;
    if (mediaStreamLabel != null && mediaStreamLabel != "") {
      creationParams["media_stream_label"] = mediaStreamLabel;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      _methodChannel?.invokeMethod("attach", creationParams);

      return PlatformViewLink(
          viewType: widget.viewType,
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              key: ValueKey('UIKitView_video_view_$viewNumber'),
              controller: controller as AndroidViewController,
              gestureRecognizers: const <
                  Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (params) {
            developer.log("onCreatePlatformView");
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: widget.viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            )
              ..addOnPlatformViewCreatedListener((id) {
                params.onPlatformViewCreated(id);
                final channel =
                    MethodChannel("video_view_${id}_method_channel");
                _methodChannel = channel;
                channel.invokeMethod("attach", creationParams);
              })
              ..create();
          });
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _methodChannel?.invokeMethod("attach", creationParams);

      return UiKitView(
        key: ValueKey('UIKitView_video_view_$viewNumber'),
        viewType: widget.viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) async {
          final channel = MethodChannel("video_view_${id}_method_channel");
          _methodChannel = channel;
          await channel.invokeMethod("attach", creationParams);
        },
      );
    }
    throw UnimplementedError();
  }

  void _updateParticipantAndStream() {
    if (widget.videoViewController != null) {
      _participant = widget.videoViewController?._participant;
      _mediaStream = widget.videoViewController?._mediaStream;
    } else {
      _participant = widget.participant;
      _mediaStream = widget.mediaStream;
    }
  }

  void _attach(Participant participant, MediaStream? mediaStream) {
    setState(() {
      _participant = participant;
      _mediaStream = mediaStream;
    });
  }

  void _detach() {
    setState(() {
      _participant = null;
      _mediaStream = null;
    });
  }

  Future<bool> _isAttached() async {
    final methodChannel = _methodChannel;
    if (methodChannel != null) {
      return methodChannel.invokeMethod<bool>("isAttached").then((value) {
        return value ?? false;
      });
    }
    return Future.error("The VideoView has not been instantiated yet.");
  }

  Future<bool> _isScreenShare() async {
    final methodChannel = _methodChannel;
    if (methodChannel != null) {
      return methodChannel.invokeMethod<bool>("isScreenShare").then((value) {
        return value ?? false;
      });
    }
    return Future.error("The VideoView has not been instantiated yet.");
  }
}
