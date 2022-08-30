import 'dart:async';
// import 'dart:collection';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';

/// A controller for the [VideoView] that is responsible for attaching a [Participant] and a [MediaStream] to the [VideoView], detaching them, and getting information about the [VideoView] state.
/// 
/// An instance of this class can be provided during the instantiation of the [VideoView] widget, 
/// if this widget is constructed using [VideoView.forList].
class VideoViewController {

  _VideoViewState?  _state;
  
  /// Attaches a [Participant] and a [MediaStream] to the [VideoView]. This allows the
  /// [VideoView] to display the provided [MediaStream] if the media stream object belongs
  /// to the provided [Participant]. 
  Future<void> attach(Participant participant, MediaStream? mediaStream) {
    final state = _state;
    if (state != null) {
      return state._attach(participant, mediaStream);
    }
    developer.log("VideoViewController.attach(): The VideoView has not been instantiated yet.");
    return Future.error("The VideoView has not been instantiated yet.");
  }

  VideoViewController();

  /// Detaches a [MediaStream] and a [Participant] from the [VideoView] to stop displaying the [MediaStream].
  Future<void> detach() async {
    final state = _state;
    if (state != null) {
      return state._detach();
    }
    developer.log("VideoViewController.detach(): The VideoView has not been instantiated yet.");
    return Future.error("The VideoView has not been instantiated yet.");
  }

  /// Returns true if a [MediaStream] is currently attached to the [VideoView].
  Future<bool> isAttached() async {
    final state = _state;
    if (state != null) {
      return state._isAttached();
    }
    developer.log("VideoViewController.isAttached(): The VideoView has not been instantiated yet.");
    return Future.value(false);
  }

  /// Returns true if the attached [MediaStream] contains a video track whose contents come from a screen shared by the local participant.
  Future<bool> isScreenShare() async {
    final state = _state;
    if (state != null) {
      return state._isScreenShare();
    }
    developer.log("VideoViewController.isScreenShare(): The VideoView has not been instantiated yet.");
    return Future.error("The VideoView has not been instantiated yet.");
  }

  void _updateState(_VideoViewState state) {
    _state = state;
  }
}

/// A closure that selects and updates a [MediaStream] that should be displayed by the [VideoView]. It 
/// must be provided to the [VideoView.forList] constructor.
typedef MediaStreamSelector = MediaStream? Function(List<MediaStream>? mediaStreams);

/// A widget that can display a [MediaStream] for a [Participant]. 
/// 
/// You can use [VideoView] in two ways, either as an item of a [GridView] or a [ListView] used with the [VideoView.forList] constructor or as a stand-alone widget outside of collection widgets, such as [GridView] or [ListView]. In this second option, you need to use the [VideoView] constructor and provide a [VideoViewController] to the constructor.
class VideoView extends StatefulWidget {

  /// @internal
  final String viewType = 'video_view';

  /// @internal
  final Participant? participant;

  /// @internal
  final MediaStream? mediaStream;

  /// @internal
  final MediaStreamSelector? mediaStreamSelector;

  /// @internal
  final VideoViewController? videoViewController;

  /// A constructor that should be used when the [VideoView] is an element in a collection 
  /// widget, such as a [GridView] or a [ListView]. The constructor requires providing the [Participant]
  /// for whom the [MediaStream] should be displayed, the [MediaStream], and an optional [Key]. 
  const VideoView.withMediaStream({required this.participant, required this.mediaStream, Key? key})
    : videoViewController = null
    , mediaStreamSelector = null
    , super(key: key)
    ;

  /// @internal
  /// 
  /// A constructor that could be used when the [VideoView] is an element in a collection 
  /// widget, such as a [GridView] or a [ListView]. The constructor requires providing the [Participant]
  /// who would like to display a [MediaStream], an optional [Key], and the [MediaStreamSelector]. 
  /// 
  /// The [MediaStreamSelector] is a closure or an unnamed function that is run internally by the 
  /// widget to decide which [MediaStream] to display. The algorithm from this closure should 
  /// return the [MediaStream] that should be displayed based on the [List] of [MediaStream]s provided as 
  /// an argument to the closure. This closure runs when the [VideoView] is created and every time the 
  /// [MediaStream]s of the related [Participant] change.
  const VideoView.withMediaStreamSelector({required this.participant, Key? key, required this.mediaStreamSelector})
    : videoViewController = null
    , mediaStream = null
    , super(key: key)
    ;

  /// A constructor that shuold be used when the [VideoView] is used as a stand-alone widget 
  /// outside of collection widgets such as [GridView] or [ListView]. The constructor requires providing 
  /// the [VideoViewController] and, optionally, a [Key].
  const VideoView({required this.videoViewController, Key? key})
    : participant = null
    , mediaStream = null
    , mediaStreamSelector = null
    , super(key: key)
    ;

  @override
  State<VideoView> createState() => _VideoViewState();

}

class _VideoViewState extends State<VideoView> {

  static int _viewNumber = 0;
  static int _getNextViewNubmer() {
    _viewNumber += 1;
    return _viewNumber;
  }

  VideoViewController? _controller;
  Participant? _participant;
  MediaStream? _mediaStream;
  StreamSubscription<dynamic>? _onStreamChangeSubscription;
  int viewNumber;
  MethodChannel? _methodChannel;

  _VideoViewState()
    : viewNumber = _getNextViewNubmer()
    ;

  @override
  void dispose() {
    _onStreamChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _controller = widget.videoViewController;
    _controller?._updateState(this);
    _participant = widget.participant;
    _refreshSubscriptionForMediaStreamSelector();
    _updateParticipantAndStream();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideoView oldWidget) {
    _controller = widget.videoViewController;
    _controller?._updateState(this);
    _participant = widget.participant;
    _refreshSubscriptionForMediaStreamSelector();
    _updateParticipantAndStream();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, String> creationParams = { };

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
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
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
              ..addOnPlatformViewCreatedListener( (id) {
                params.onPlatformViewCreated(id);
                final channel = MethodChannel("video_view_${id}_method_channel");
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

  void _refreshSubscriptionForMediaStreamSelector() {

    _onStreamChangeSubscription?.cancel();
    _onStreamChangeSubscription = null;

    if (widget.mediaStreamSelector != null) {
      _onStreamChangeSubscription = DolbyioCommsSdk.instance.conference.onStreamsChange()
        .listen((e) async {

          final mediaStreamSelector = widget.mediaStreamSelector;
          if (_participant?.id == e.body.participant.id && mediaStreamSelector != null) {
            setState(() {
              _participant = e.body.participant;
              _mediaStream = mediaStreamSelector(e.body.participant.streams);
            });
          }

          return Future.value();
        });
    }
  }

  void _updateParticipantAndStream() {
    final participant = _participant;
    final mediaStream = widget.mediaStream;
    final mediaStreamSelector = widget.mediaStreamSelector;
    if (participant != null) {
      if (mediaStreamSelector != null) {
        setState(() {
          _participant = participant;
          _mediaStream = mediaStreamSelector(participant.streams);
        });
      } else if (mediaStream != null) {
        setState(() {
          _participant = participant;
          _mediaStream = mediaStream;
        });
      }
    }
  }

  Future<void> _attach(Participant participant, MediaStream? mediaStream) async {
    final methodChannel = _methodChannel;
      if (methodChannel != null) {
      return methodChannel.
        invokeMethod<bool>(
          "attach", 
          {
            "participant_id": participant.id, 
            "media_stream_id": mediaStream?.id
          }
        )
        .then((value) {
          _participant = participant;
          _mediaStream = mediaStream;
        });
    }
    return Future.error("The VideoView has not been instantiated yet.");
  }

  Future<void> _detach() async {
    final methodChannel = _methodChannel;
    if (methodChannel != null) {
      return _methodChannel
        ?.invokeMethod<bool>("detach")
        .then((value) => null)
        .then((value) {
          _participant = null;
          _mediaStream = null;
        });
    }
    return Future.error("The VideoView has not been instantiated yet.");
  }

  Future<bool> _isAttached() async {
    final methodChannel = _methodChannel;
    if (methodChannel != null) {
      return methodChannel.invokeMethod<bool>("isAttached").then((value) {
        return value ?? false;
      }  );
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
