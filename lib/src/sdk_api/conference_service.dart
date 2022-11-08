import 'dart:async';
import 'dart:convert';
import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../dolbyio_comms_sdk_native_events.dart';
import '../mapper/mapper.dart';
import 'models/conference.dart';
import 'models/events.dart';
import 'models/participant.dart';
import 'models/spatial.dart';
import 'session_service.dart';

/// The ConferenceService allows an application to manage a conference life-cycle and interact with the conference. The service allows creating, joining, and leaving conferences and managing the audio, video, and screen-share streams.
///
/// {@category Services}
class ConferenceService {
  /// @internal
  final _methodChannel =
      DolbyioCommsSdkFlutterPlatform.createMethodChannel("conference_service");

  /// @internal */
  late final _nativeEventsReceiver = DolbyioCommsSdkNativeEventsReceiver<
      ConferenceServiceEventNames>.forModuleNamed("conference_service");

  final SessionService _sessionService;

  ConferenceService(this._sessionService);

  /// Creates a conference and returns the Conference object. The [options] parameter allows setting the conference preferences.
  Future<Conference> create(ConferenceCreateOption options) async {
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
            "create", options.toJson()) ??
        <String, Object?>{};
    return ConferenceMapper.fromMap(result);
  }

  /// Returns the Conference object for the current conference.
  Future<Conference> current() async {
    var result =
        await _methodChannel.invokeMethod<Map<Object?, Object?>>("current") ??
            <String, Object?>{};
    return ConferenceMapper.fromMap(result);
  }

  /// Returns the Conference object that you can use to join the conference. If the [conferenceId] parameter is not provided, the method returns the current Conference object.
  Future<Conference> fetch(String? conferenceId) async {
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
            "fetch", {"conferenceId": conferenceId}) ??
        <String, Object?>{};
    return ConferenceMapper.fromMap(result);
  }

  /// Returns the participant's audio level. Audio level values are in the range 0 to 1.
  /// The [participant] parameter refers to the participant whose audio level should be returned.
  Future<AudioLevel> getAudioLevel(Participant participant) async {
    var result = await _methodChannel.invokeMethod<num>(
        "getAudioLevel", participant.toJson());
    return result as AudioLevel;
  }

  /// Joins a conference as a user who can send media to the conference.
  /// The [conference] parameter refers to the conference that tha local participant wants to join.
  /// The [options] parameter allows setting additional options for the joining participant.
  Future<Conference> join(
      Conference conference, ConferenceJoinOptions options) async {
    var arguments = {
      "conference": conference.toJson(),
      "options": options.toJson()
    };
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
            "join", arguments) ??
        <String, Object?>{};
    return ConferenceMapper.fromMap(result);
  }

  /// Leaves the current conference. The [options] parameter allows setting additional options for the leaving participant.
  /// The [options] parameter allows choosing additional options for the leaving participant.
  Future<void> leave({ConferenceLeaveOptions? options}) async {
    await _methodChannel.invokeMethod<void>("leave");
    if (options != null && options.leaveRoom) {
      await _sessionService.close();
      return;
    }
    return;
  }

  /// Kicks a participant out of the current conference. This method is available only for conference owners or participants who have the adequate permissions to kick a participant. The [participant] parameter refers to the participant who should be kicked out of the conference.
  Future<void> kick(Participant participant) async {
    return await _methodChannel.invokeMethod<void>(
        "kick", participant.toJson());
  }

  /// Gets a list of participants who are present at a specific conference defined in the [conference] parameter.
  /// **Note**: If a session is closed and reopened, the list obtained from the getParticipants method can sometimes get corrupted. This can result in no preview video being displayed for the local participant or the local participant appearing twice on the list.
  Future<List<Participant>> getParticipants(Conference conference) async {
    var result = await _methodChannel.invokeMethod<List<Object?>>(
        "getParticipants", conference.toJson());
    return result != null
        ? result
            .map((e) => ParticipantMapper.fromMap(e as Map<Object?, Object?>))
            .toList()
        : List.empty();
  }

  /// Stops playing a specific remote participant's audio to the local participant or stops playing the local participant's audio to the conference. The [participant] parameter refers to the participant who should be muted. The [isMuted] parameter enables and disables audio; true indicates that the SDK should mute the participant, false indicates that the participant should not be muted.
  Future<bool> mute(Participant participant, bool isMuted) async {
    var arguments = {"participant": participant.toJson(), "isMuted": isMuted};
    var result = await _methodChannel.invokeMethod<bool>("mute", arguments);
    return Future.value(result);
  }

  /// Controls playing remote participants' audio to the local participant.
  /// Note: This API is only supported when the client connects to a Dolby Voice conference.
  /// The [isMuted] parameter enables and disables audio.
  Future<bool> muteOutput(bool isMuted) async {
    var result = await _methodChannel
        .invokeMethod<bool>("muteOutput", {"isMuted": isMuted});
    return Future.value(result);
  }

  /// Returns the current mute state of the local participant.
  Future<bool> isMuted() async {
    return Future.value(await _methodChannel.invokeMethod<bool>("isMuted"));
  }

  /// Sets a participant's [position] in space to enable the spatial audio experience during a Dolby Voice conference. This method is available only for participants who joined the conference using the [ConferenceService.join] method with the [ConferenceJoinOptions.spatialAudio] parameter enabled. Otherwise, SDK triggers an error. To set a spatial position for listeners, use the [Set Spatial Listeners Audio](https://docs.dolby.io/communications-apis/reference/set-spatial-listeners-audio) REST API.
  ///
  /// Depending on the specified participant in the [participant] parameter, the setSpatialPosition method impacts the location from which audio is heard or from which audio is rendered:
  ///
  /// - When the specified participant is the local participant, setSpatialPosition sets the location from which the local participant listens to the conference. If this location is not provided, the participant hears audio from the default location (0, 0, 0).
  ///
  /// - When the specified participant is a remote participant, setSpatialPosition ensures the remote participant's audio is rendered from the specified location in space. Setting the remote participants’ positions is required in conferences that use the individual [SpatialAudioStyle]. In these conferences, if a remote participant does not have an established location, the participant does not have a default position and will remain muted until a position is specified. The shared spatial audio style does not support setting the remote participants' positions. In conferences that use the shared style, the spatial scene is shared by all participants, so that each client can set a position and participate in the shared scene.
  ///
  /// For example, if a local participant Eric, who does not have a set direction, calls setSpatialPosition(VoxeetSDK.session.participant, {x:3,y:0,z:0}), Eric hears audio from the position (3,0,0). If Eric also calls setSpatialPosition(Sophia, {x:7,y:1,z:2}), he hears Sophia from the position (7,1,2). In this case, Eric hears Sophia 4 meters to the right, 1 meter above, and 2 meters in front. The following graphic presents the participants' locations:
  ///
  /// <img src="https://files.readme.io/d4d9f7a-05_Axis_People_v04_220202.png" width="700">
  ///
  Future<void> setSpatialPosition(
      {required Participant participant,
      required SpatialPosition position}) async {
    await _methodChannel.invokeMethod<void>("setSpatialPosition",
        {"participant": participant.toJson(), "position": position.toJson()});
    return Future.value();
  }

  /// Starts audio transmission between the local client and a conference. The startAudio method impacts only the audio streams that the local participant sends and receives; the method does not impact the audio transmission between remote participants and a conference and does not allow the local participant to force sending remote participants’ streams to the conference or to the local participant. Depending on the specified participant in the [participant] parameter, the startAudio method starts the proper audio transmission:
  /// - When the specified participant is the local participant, startAudio ensures sending local participant’s audio from the local client to the conference.
  /// - When the specified participant is a remote participant, startAudio ensures sending remote participant’s audio from the conference to the local client. This allows the local participant to un-mute remote participants who were locally muted via the [ConferenceService.stopAudio] method.
  Future<void> startAudio(Participant participant) async {
    await _methodChannel.invokeMethod<void>("startAudio", participant.toJson());
    return Future.value();
  }

  /// Notifies the server to either start sending the local participant's video stream to the conference or start sending a remote participant's video stream to the local participant. The behavior depends on the specified participant in [participant] parameter. The startVideo method does not control the remote participant's video stream; if a remote participant does not transmit any video stream, the local participant cannot change it using the startVideo method.
  Future<void> startVideo(Participant participant) async {
    await _methodChannel.invokeMethod<void>("startVideo", participant.toJson());
    return Future.value();
  }

  /// Stops audio transmission between the local client and a conference. The stopAudio method impacts only the audio streams that the local participant sends and receives; the method does not impact the audio transmission between remote participants and a conference and does not allow the local participant to stop sending remote participants’ streams to the conference. Depending on the specified participant in the [participant] parameter, the stopAudio method stops the proper audio transmission:
  /// - When the specified participant is the local participant, stopAudio stops sending local participant’s audio from the local client to the conference.
  /// - When the specified participant is a remote participant, stopAudio stops sending remote participant’s audio from the conference to the local client. This allows the local participant to locally mute remote participants.
  Future<void> stopAudio(Participant participant) async {
    await _methodChannel.invokeMethod<void>("stopAudio", participant.toJson());
    return Future.value();
  }

  /// Notifies the server to either stop sending the local participant's video stream to the conference or stop sending a remote participant's video stream to the local participant. The behavior depends on the specified participant in [participant] parameter.
  Future<void> stopVideo(Participant participant) async {
    await _methodChannel.invokeMethod<void>("stopVideo", participant.toJson());
    return Future.value();
  }

  /// Starts a screen sharing session.
  /// For iOS, see the [ScreenShare with iOS document](https://docs.dolby.io/communications-apis/docs/screenshare-with-ios) that describes how to set up screen share outside the application.
  ///
  /// Additionally, instead of setting the following properties:
  /// - CommsSDK.shared.appGroup = "YOUR_APP_GROUP"
  /// - CommsSDK.shared.preferredExtension = "YOUR_BROADCAST_EXTENSION_BUNDLE_ID"
  ///
  ///  Set up keys in your `Info.plist` file:
  /// - Add a new `DolbyioSdkAppGroupKey` as a string type and enter the group name ("YOUR_APP_GROUP").
  /// - Add a new `DolbyioSdkPreferredExtensionKey` as a string type and enter the broadcast extension bundle ID ("YOUR_BROADCAST_EXTENSION_BUNDLE_ID").
  Future<void> startScreenShare() async {
    await _methodChannel.invokeMethod<void>("startScreenShare");
    return Future.value();
  }

  /// Stops a screen sharing session.
  Future<void> stopScreenShare() async {
    await _methodChannel.invokeMethod<void>("stopScreenShare");
    return Future.value();
  }

  /// Sets the [direction] the local participant is facing in space. This method is available only for participants who joined the conference using the [ConferenceService.join] method with the [ConferenceJoinOptions.spatialAudio] parameter enabled. Otherwise, SDK triggers an error. To set a spatial direction for listeners, use the [Set Spatial Listeners Audio](https://docs.dolby.io/communications-apis/reference/set-spatial-listeners-audio) REST API.
  ///
  /// If the local participant hears audio from the position (0,0,0) facing down the Z-axis and locates a remote participant in the position (1,0,1), the local participant hears the remote participant from front-right. If the local participant chooses to change the direction and rotate +90 degrees about the Y-axis, then instead of hearing the speaker from the front-right position, the participant hears the speaker from the front-left position. The following video presents this example:
  ///
  /// <div style="text-align:center"><video controls width="700"> <source src="https://s3.us-west-1.amazonaws.com/static.dolby.link/videos/readme/communications/spatial/07_setSpatialDirection_v03_220131.mp4" type="video/mp4"> Sorry, your browser doesn't support embedded videos.</video></div>
  ///
  /// For more information, see the [SpatialDirection] model.
  Future<void> setSpatialDirection(SpatialDirection direction) async {
    await _methodChannel.invokeMethod<void>(
        "setSpatialDirection", direction.toJson());
    return Future.value();
  }

  /// Configures a spatial environment of an application, so the audio renderer understands which directions the application considers forward, up, and right and which units it uses for distance. This method is available only for participants who joined a conference using the [ConferenceService.join] method with the [ConferenceJoinOptions.spatialAudio] parameter enabled. Otherwise, SDK triggers an error. To set a spatial environment for listeners, use the [Set Spatial Listeners Audio](https://docs.dolby.io/communications-apis/reference/set-spatial-listeners-audio) REST API.
  ///
  /// The method uses the following parameters:
  /// - [scale]: A scale that defines how to convert units from the coordinate system of an application (pixels or centimeters) into meters used by the spatial audio coordinate system. For example, if SpatialScale is set to (100,100,100), it indicates that 100 of the applications units (cm) map to 1 meter for the audio coordinates. In such a case, if the listener's location is (0,0,0)cm and a remote participant's location is (200,200,200)cm, the listener has an impression of hearing the remote participant from the (2,2,2)m location. The scale value must be greater than 0. For more information, see the [Spatial Audio](https://docs.dolby.io/communications-apis/docs/guides-integrating-individual-spatial-audio#configure-the-spatial-environment-scale) article.
  /// - [forward]: A vector describing the direction the application considers as forward. The value can be either +1, 0, or -1 and must be orthogonal to up and right.
  /// - [up]: A vector describing the direction the application considers as up. The value can be either +1, 0, or -1 and must be orthogonal to forward and right.
  /// - [right]: A vector describing the direction the application considers as right. The value can be either +1, 0, or -1 and must be orthogonal to forward and up.
  ///
  /// If not called, the SDK uses the default spatial environment, which consists of the following values:
  ///
  /// - `forward` = (0, 0, 1), where +Z axis is in front
  /// - `up` = (0, 1, 0), where +Y axis is above
  /// - `right` = (1, 0, 0), where +X axis is to the right
  /// - `scale` = (1, 1, 1), where one unit on any axis is 1 meter
  ///
  /// The default spatial environment is presented in the following diagram:
  ///
  /// <img src="https://files.readme.io/e43475b-defaultEnv.png" width="700">
  ///
  Future<void> setSpatialEnvironment(
      SpatialScale scale,
      SpatialPosition forward,
      SpatialPosition up,
      SpatialPosition right) async {
    await _methodChannel.invokeMethod<void>("setSpatialEnvironment", {
      "scale": scale.toJson(),
      "forward": forward.toJson(),
      "up": up.toJson(),
      "right": right.toJson(),
    });
    return Future.value();
  }

  /// Returns the participant's current speaking status for the active talker indicator. The [participant] parameter refers to the participant whose speaking status the local participant would like to receive.
  Future<bool> isSpeaking(Participant participant) async {
    return Future.value(await _methodChannel.invokeMethod<bool>(
        "isSpeaking", participant.toJson()));
  }

  /// Gets the status of a specific [conference].
  Future<ConferenceStatus> getStatus(Conference conference) async {
    var result = await _methodChannel.invokeMethod<String>(
        "getStatus", conference.toJson());
    return Future.value(
        result != null ? ConferenceStatus.decode(result) : null);
  }

  /// Gets the [standard WebRTC statistics](https://www.w3.org/TR/webrtc-stats/#dom-rtcstatstype).
  Future<Map<String, dynamic>> getLocalStats() async {
    final result =
        await _methodChannel.invokeMapMethod<String, String>("getLocalStats");
    if (result != null) {
      final map = <String, dynamic>{};
      result.forEach((key, value) {
        map[key] = jsonDecode(value);
      });
      return map;
    }
    return {};
  }

  /// Returns the maximum number of video streams that can be transmitted to the local participant.
  Future<MaxVideoForwarding> getMaxVideoForwarding() async {
    var result =
        await _methodChannel.invokeMethod<num>("getMaxVideoForwarding");
    return Future.value(result as MaxVideoForwarding);
  }

  /// Sets the maximum number of video streams that may be transmitted to the local participant.
  ///
  /// This method uses the following parameters:
  /// - [max]: The maximum number of video streams that may be transmitted to the local participant. The valid parameter values are between 0 and 4. By default, the parameter is set to 4.
  /// - [prioritizedParticipants]: The list of the prioritized participants. This parameter allows using a pin option to prioritize specific participant's video streams and display their videos even when these participants do not talk.
  @Deprecated(
      'This method is supported only in SDK 3.6.0. To set Video Forwarding in SDK 3.6.1 and later, use the [ConferenceService.setVideoForwarding()] method.')
  Future<bool> setMaxVideoForwarding(
      MaxVideoForwarding max, List<Participant> prioritizedParticipants) async {
    final result =
        await _methodChannel.invokeMethod<bool>("setMaxVideoForwarding", {
      "max": max,
      "prioritizedParticipants":
          prioritizedParticipants.map((e) => e.toJson()).toList()
    });
    return Future.value(result);
  }

  ///Sets the maximum number of video streams that may be transmitted to the local participant.
  ///For more information, see the
  ///[Video Forwarding](https://docs.dolby.io/communications-apis/docs/guides-video-forwarding) article.
  ///
  /// This method uses the following parameters:
  /// - [strategy]: Defines how the SDK should select conference participants whose videos will be
  ///transmitted to the local participant. There are two possible values; the selection can be either
  ///based on the participants' audio volume or the distance from the local participant
  /// - [max]: The maximum number of video streams that may be transmitted to the local
  ///participant. The valid values are between 0 and 4. The default value is 4.
  ///In the case of providing a value smaller than 0 or greater than 4, SDK triggers
  ///an error.
  /// - [prioritizedParticipants]: The list of participants' objects. Allows prioritizing specific participant's
  ///video streams and display their videos even when these participants do not talk.
  ///For example, in the case of virtual classes, this option allows participants to pin the teacher's
  ///video and see the teacher, even when the teacher is not the active speaker.
  Future<bool> setVideoForwarding(
    VideoForwardingStrategy strategy,
    MaxVideoForwarding max,
    List<Participant> prioritizedParticipants,
  ) async {
    final result = await _methodChannel.invokeMethod<bool>(
      "setVideoForwarding",
      {
        "strategy": strategy.encode(),
        "max": max,
        "prioritizedParticipants":
            prioritizedParticipants.map((e) => e.toJson()).toList()
      },
    );
    return Future.value(result ?? false);
  }

  /// Gets the Participant object based on the [participantId].
  Future<Participant> getParticipant(String participantId) async {
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
        "getParticipant", {"participantId": participantId});
    return Future.value(
        result != null ? ParticipantMapper.fromMap(result) : null);
  }

  /// Replays a recorded [conference]. The [replayOptions] parameter refers to additional replay options that you can define. For more information, see the [Recording Conferences](https://docs.dolby.io/communications-apis/docs/guides-recording-conferences) article.
  Future<Conference> replay(
      {required Conference conference,
      ConferenceReplayOptions? replayOptions}) async {
    var arguments = {
      "conference": conference.toJson(),
      "offset": replayOptions?.offset,
      "conferenceAccessToken": replayOptions?.conferenceAccessToken
    };
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
        "replay", arguments);
    return Future.value(
        result != null ? ConferenceMapper.fromMap(result) : null);
  }

  /// Enables and disables audio processing for the local participant. The [options] parameter refers to additional audio processing options.
  Future<void> setAudioProcessing(AudioProcessingOptions options) async {
    await _methodChannel.invokeMethod<void>(
        "setAudioProcessing", options.toJson());
    return Future.value();
  }

  /// Updates the participant's conference permissions. The [participantPermissions] parameter allows assigning the required permissions to specific participants.
  Future<void> updatePermissions(
      List<ParticipantPermissions> participantPermissions) async {
    await _methodChannel.invokeMethod<void>("updatePermissions",
        participantPermissions.map((e) => e.toJson()).toList());
    return Future.value();
  }

  /// Joins a conference as a listener.
  /// The [conference] parameter refers to the conference that tha local participant wants to join as a listener.
  /// The [options] parameter allows setting additional options for the joining participant.
  Future<Conference> listen(Conference conference, ConferenceListenOptions options) async {
    var arguments = {
      "conference": conference.toJson(),
      "options": options.toJson()
    };
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
            "listen", arguments) ??
        <String, Object?>{};
    return ConferenceMapper.fromMap(result);
  }

  /// Returns a [Stream] of the [ConferenceServiceEventNames.statusUpdated] events. By subscribing to the returned stream you will be notified about conference status changes.
  Stream<Event<ConferenceServiceEventNames, ConferenceStatus>>
      onStatusChange() {
    return _nativeEventsReceiver
        .addListener([ConferenceServiceEventNames.statusUpdated]).map((event) {
      final eventMap = event as Map<Object?, Object?>;
      final eventType =
          ConferenceServiceEventNames.valueOf(eventMap["key"] as String);
      final status = ConferenceStatus.decode(eventMap["body"] as String) ??
          ConferenceStatus.defaultStatus;
      return Event(eventType, status);
    });
  }

  /// Returns a [Stream] of the [ConferenceServiceEventNames.permissionsUpdated] events. By subscribing to the returned stream you will be notified about conference permissions changes.
  Stream<Event<ConferenceServiceEventNames, List<ConferencePermission>>>
      onPermissionsChange() {
    return _nativeEventsReceiver.addListener(
        [ConferenceServiceEventNames.permissionsUpdated]).map((event) {
      final eventMap = event as Map<Object?, Object?>;
      final eventType =
          ConferenceServiceEventNames.valueOf(eventMap["key"] as String);
      final permissions =
          PermissionsUpdatedMapper.fromList(eventMap["body"] as List<Object?>);
      return Event(eventType, permissions);
    });
  }

  /// Returns a [Stream] of the [ConferenceServiceEventNames.participantAdded] and [ConferenceServiceEventNames.participantUpdated] events. By subscribing to the returned stream you will be notified about changed statuses of conference participants and new participants in a conference.
  Stream<Event<ConferenceServiceEventNames, Participant>>
      onParticipantsChange() {
    return _nativeEventsReceiver.addListener([
      ConferenceServiceEventNames.participantAdded,
      ConferenceServiceEventNames.participantUpdated,
    ]).map((event) {
      final eventMap = event as Map<Object?, Object?>;
      final eventType =
          ConferenceServiceEventNames.valueOf(eventMap["key"] as String);
      final participant =
          ParticipantMapper.fromMap(eventMap["body"] as Map<Object?, Object?>);
      return Event(eventType, participant);
    });
  }

  /// Returns a [Stream] of the [ConferenceServiceEventNames.streamAdded], [ConferenceServiceEventNames.streamUpdated], and [ConferenceServiceEventNames.streamRemoved] events. By subscribing to the returned stream you will be notified about new, changed, and removed streams of conference participants.
  Stream<Event<ConferenceServiceEventNames, StreamsChangeData>>
      onStreamsChange() {
    return _nativeEventsReceiver.addListener([
      ConferenceServiceEventNames.streamAdded,
      ConferenceServiceEventNames.streamUpdated,
      ConferenceServiceEventNames.streamRemoved
    ]).map((event) {
      final eventMap = event as Map<Object?, Object?>;
      final eventType =
          ConferenceServiceEventNames.valueOf(eventMap["key"] as String);
      final streamsChangeData = eventMap["body"] as Map<Object?, Object?>;
      return Event(
          eventType,
          StreamsChangeData(
              ParticipantMapper.fromMap(
                  streamsChangeData["participant"] as Map<Object?, Object?>),
              MediaStreamMapper.fromMap(
                  streamsChangeData["stream"] as Map<Object?, Object?>)));
    });
  }
}

typedef AudioLevel = num;
typedef MaxVideoForwarding = int;
