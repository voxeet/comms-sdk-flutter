// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'participant.dart';
import 'enums.dart';

/// The Conference class gathers information about a conference.
class Conference {
  /// The conference alias. The alias is case insensitive, which means that using "foobar" and "FOObar" aliases results in joining the same conference.
  String? alias;

  /// The conference ID.
  String? id;

  /// A boolean indicating if the created conference is new.
  bool? isNew;

  /// A list of conference participants.
  List<Participant> participants;

  /// The current conference status.
  ConferenceStatus status;

  Conference(this.alias, this.id, this.isNew, this.participants, this.status);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "alias": alias,
        "id": id,
        "isNew": isNew,
        "participants": participants.map((e) => e.toJson()).toList(),
        "status": status.encode(),
      };
}

/// The ConferenceStatus enum represents the possible conference statuses.
enum ConferenceStatus {
  /// The conference has been created.
  created('CREATED'),

  /// The SDK is currently creating the conference.
  creating('CREATING'),

  /// The default conference status.
  defaultStatus('DEFAULT'),

  /// The conference has been destroyed. This status may be triggered by the following situations:
  /// - The last conference participant leaves the conference
  /// - The time to live or the conference time limit elapses
  /// - The conference creator uses the Terminate REST API to terminate the conference
  destroyed('DESTROYED'),

  /// A conference has ended.
  ended('ENDED'),

  /// An error has occurred.
  error('ERROR'),

  /// @internal
  /// @nodoc
  firstParticipant('FIRST_PARTICIPANT'),

  /// The local participant has successfully joined the conference.
  joined('JOINED'),

  /// The local participant is joining the conference.
  joining('JOINING'),

  /// The local participant is leaving the conference.
  leaving('LEAVING'),

  /// The local participant has successfully left the conference.
  left('LEFT'),

  /// @internal
  /// @nodoc
  noMoreParticipant('NO_MORE_PARTICIPANT');

  final String _value;

  const ConferenceStatus(this._value);

  /// @internal
  static ConferenceStatus? decode(String value) {
    return ConferenceStatus.values.firstWhereOrNull((element) => element._value == value);
  }

  /// @internal
  String encode() {
    return _value;
  }
}

/// The ConferenceCreateOption class allows defining conference details.
class ConferenceCreateOption {
  /// The conference alias. The alias must be a logical and unique string that consists of up to 250 characters, such as letters, digits, and symbols other than #. The alias is case insensitive, which means that using "foobar" and "FOObar" aliases refers to the same conference.
  String? alias;

  /// The conference parameters.
  ConferenceCreateParameters? params;

  /// The PIN code of a conference.
  num pinCode;

  ConferenceCreateOption(this.alias, this.params, this.pinCode);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "alias": alias,
        "params": params?.toJson(),
        "pinCode": pinCode,
      };
}

/// The ConferenceCreateParameters class allows defining conference parameters.
class ConferenceCreateParameters {
  /// A boolean that indicates whether an application wishes to create a conference with Dolby Voice enabled. For more information about Dolby Voice, see the [Dolby Voice](https://docs.dolby.io/communications-apis/docs/guides-dolby-voice) article. By default, the parameter is set to true.
  bool dolbyVoice = false;

  /// A boolean that enables and disables live recording. Specify this parameter during the conference creation:
  /// - When set to true, the recorded file is available at the end of the call and can be downloaded immediately.
  /// - When set to false, the [remix API](https://docs.dolby.io/communications-apis/reference/introduction-to-remix-api) must be called after the conference to generate and retrieve the recorded file.
  ///
  /// This parameter does not start the recording; use the [RecordingService.start] method to enable the recording. For more information, see the [Recording Conferences](https://docs.dolby.io/communications-apis/docs/guides-recording-conferences) article.
  bool? liveRecording;

  /// The bitrate adaptation mode for video transmission. The parameter triggers a server to monitor the receivers’ available bandwidth. Based on the analyzed value, the server informs the video sender to automatically adjust the quality of the transmitted video streams.
  RTCPMode? rtcpMode;

  /// The time to live that allows customizing time after which the SDK terminates empty conferences (is seconds). The default ttl value is 0.
  num? ttl;

  /// The preferred video codec, either H264 or VP8. By default, the SDK uses the H264 codec.
  Codec? videoCodec;

  /// Returns a representation of this object as a JSON object.
  Map<String, dynamic> toJson() => {
        "dolbyVoice": dolbyVoice,
        "liveRecording": liveRecording,
        "rtcpMode": rtcpMode?.encode(),
        "ttl": ttl,
        "videoCodec": videoCodec?.encode(),
      };
}

/// The RTCPMode enum gathers the possible bitrate adaptation modes for video transmission.
enum RTCPMode {
  /// Averages the available bandwidth of all receivers and adjusts the transmission bitrate to this value.
  average('average'),

  /// Does not adjust the transmission bitrate to the receivers' bandwidth.
  best('best'),

  /// Adjusts the transmission bitrate to the receiver who has the worst network conditions.
  worst('worst');

  final String _value;

  const RTCPMode(this._value);

  String encode() {
    return _value;
  }
}

/// The Codec enum gathers the available video codecs.
enum Codec {
  /// The default H264 video codec.
  h264('H264'),

  /// The VP8 video codec.
  vp8('VP8');

  final String _value;

  /// @internal
  const Codec(this._value);

  /// @internal
  String encode() { 
    return _value;
  }
}

/// The ConferenceJoinOptions class defines how an application expects to join a conference in terms of media preference.

class ConferenceJoinOptions {
  /// The conference access token that is required to join a protected conference if the conference is created using the [create](https://docs.dolby.io/communications-apis/reference/create-conference) REST API. If the conference is created using the create method, the token is managed by the SDK and is not visible to the application users. For more information, see the [Enhanced Conference Access Control](https://docs.dolby.io/communications-apis/docs/guides-enhanced-conference-access-control) document.
  String? conferenceAccessToken;

  /// Sets the conference [WebRTC constraints](https://webrtc.org/getting-started/media-capture-and-constraints#constraints). By default, only audio is enabled: `{audio: true, video: false}`.
  ConferenceConstraints? constraints;

  /// Sets the maximum number of video streams that may be transmitted to the joining participant. The valid parameter values are between 0 and 4 for mobile browsers. By default, the parameter is set to 4.
  num? maxVideoForwarding;

  /// Allows joining a conference as a special participant called Mixer. For more information, see the [Recording Conferences](https://docs.dolby.io/communications-apis/docs/guides-recording-conferences) article.
  ConferenceMixingOptions? mixing;

  /// Indicates whether a participant wants to receive mono sound. By default, participants receive stereo audio. This configuration is only applicable when using the Opus codec.
  bool? preferRecvMono;

  /// Indicates whether a participant wants to send mono sound to a conference. By default, when using the Opus codec, participants' audio is sent as stereo. This configuration is only applicable when using the Opus codec.
  bool? preferSendMono;

  /// Enables sending the Simulcast video streams to other conference participants.
  bool? simulcast;

  /// Enables spatial audio for the local participant who joins a Dolby Voice conference. By default, this parameter is set to false. When set to true in a conference that uses the individual [SpatialAudioStyle], the application must place remote participants in a 3D space using the [ConferenceService.setSpatialPosition] method.
  bool? spatialAudio;

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "constraints": constraints?.toJson(),
        "conferenceAccessToken": conferenceAccessToken,
        "maxVideoForwarding": maxVideoForwarding,
        "mixing": mixing?.toJson(),
        "preferRecvMono": preferRecvMono,
        "preferSendMono": preferSendMono,
        "simulcast": simulcast,
        "spatialAudio": spatialAudio,
      };
}

/// The ConferenceConstraints class gathers information about the preferred [WebRTC constraints](https://webrtc.org/getting-started/media-capture-and-constraints#constraints).
class ConferenceConstraints {
  /// A boolean that indicates whether audio should be enabled for the local participant.
  bool audio;

  /// A boolean that indicates whether video should be enabled for the local participant.
  bool video;

  ConferenceConstraints(this.audio, this.video);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "audio": audio,
        "video": video,
      };
}

/// The ConferenceMixingOptions class is responsible for notifying the Dolby.io server that a participant who joins or replays a conference is a special participant called Mixer. Mixer can use the SDK to record or replay a conference. For more information, see the [Recording Conferences](https://docs.dolby.io/communications-apis/docs/guides-recording-conferences) article.
class ConferenceMixingOptions {
  /// A boolean that notifies the server whether a participant is a Mixer (true) or not (false).
  bool enabled;

  ConferenceMixingOptions(this.enabled);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "enabled": enabled,
      };
}

/// The ConferenceLeaveOptions class gathers information about preferences for leaving a conference.
class ConferenceLeaveOptions {
  /// A boolean indicating whether the SDK should close a session after leaving a conference or leave the session open.
  bool leaveRoom;

  ConferenceLeaveOptions(this.leaveRoom);
}

/// @nodoc
/// @internal
enum RTCStatsType {
  /// Statistics for a codec that is currently being used by RTP streams being sent or received by this RTCPeerConnection object. It is accessed by the RTCCodecStats.
  codec('codec'),

  /// Statistics for an inbound RTP stream that is currently received with this RTCPeerConnection object. It is accessed by the RTCInboundRtpStreamStats.
  inboundRtp('inbound-rtp'),

  /// Statistics for an outbound RTP stream that is currently sent with this RTCPeerConnection object. It is accessed by the RTCOutboundRtpStreamStats.
  outboundRtp('outbound-rtp'),

  /// Statistics for the remote endpoint's inbound RTP stream corresponding to an outbound stream that is currently sent with this RTCPeerConnection object.
  remoteInboundRtp('remote-inbound-rtp'),

  /// Statistics for the remote endpoint's outbound RTP stream corresponding to an inbound stream that is currently received with this RTCPeerConnection object.
  remoteOutboundRtp('remote-outbound-rtp'),

  /// Statistics for the media produced by a MediaStreamTrack that is currently attached to an RTCRtpSender.
  mediaSource('media-source'),

  /// Statistics for a contributing source (CSRC) that contributed to an inbound RTP stream.
  csrc('csrc'),

  /// Statistics related to the RTCPeerConnection object.
  peerConnection('peer-connection'),

  /// Statistics related to each RTCDataChannel id.
  dataChannel('data-channel'),

  /// Contains statistics related to a specific MediaStream.
  stream('stream'),

  /// Statistics related to a specific MediaStreamTrack's attachment to an RTCRtpSender and the corresponding media-level metrics.
  track('track'),

  /// Statistics related to a specific RTCRtpTransceiver.
  transceiver('transceiver'),

  /// Statistics related to a specific RTCRtpSender and the corresponding media-level metrics.
  sender('sender'),

  /// Statistics related to a specific receiver and the corresponding media-level metrics.
  receiver('receiver'),

  /// Transport statistics related to the RTCPeerConnection object.
  transport('transport'),

  /// SCTP transport statistics related to an RTCSctpTransport object.
  sctpTransport('sctp-transport'),

  /// ICE candidate pair statistics related to the RTCIceTransport objects.
  candidatePair('candidate-pair'),

  /// ICE local candidate statistics related to the RTCIceTransport objects.
  localCandidate('local-candidate'),

  /// ICE remote candidate statistics related to the RTCIceTransport objects.
  remoteCandidate('remote-candidate'),

  /// Information about a certificate used by an RTCIceTransport.
  certificate('certificate'),

  /// Information about the connection to an ICE server (e.g. STUN or TURN).
  iceServer('ice-server');

  final String _value;

  const RTCStatsType(this._value);

  static RTCStatsType decode(String value) {
    return RTCStatsType.values.firstWhere((element) => element._value == value);
  }
}

/// The ConferenceReplayOptions class contains options for replaying conferences.
class ConferenceReplayOptions {
  /// The conference access token.
  String? conferenceAccessToken;

  /// The number of milliseconds between the beginning of the recording and the required replay starting point. This property allows application users to start replaying a recorded conference at a specific timestamp.
  int offset;

  ConferenceReplayOptions(this.conferenceAccessToken, this.offset);
}

/// The ConferencePermission enum gathers the possible permissions a participant may have in a conference.
enum ConferencePermission {
  /// Allows a participant to invite other participants to a conference.
  invite('INVITE'),

  /// Allows a participant to join a conference.
  join('JOIN'),

  /// Allows a participant to kick other participants from a conference
  kick('KICK'),

  /// Allows a participant to record a conference.
  record('RECORD'),

  /// Allows a participant to send an audio stream during a conference.
  sendAudio('SEND_AUDIO'),

  /// Allows a participant to send a message to other participants during a conference.
  sendMessage('SEND_MESSAGE'),

  /// Allows a participant to send a video stream during a conference.
  sendVideo('SEND_VIDEO'),

  /// Allows a participant to share a file during a conference.
  shareFile('SHARE_FILE'),

  /// Allows a participant to share a screen during a conference.
  shareScreen('SHARE_SCREEN'),

  /// Allows a participant to share a video during a conference.
  shareVideo('SHARE_VIDEO'),

  /// Allows a participant to stream a conference.
  stream('STREAM'),

  /// Allows a participant to update other participants' permissions.
  updatePermissions('UPDATE_PERMISSIONS');

  final String _value;

  const ConferencePermission(this._value);

  static ConferencePermission decode(String? value) {
    return ConferencePermission.values.firstWhere(
      (element) => element._value == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }

  String encode() {
    return _value;
  }
}

/// The ConferenceServiceEventNames enum gathers events that inform about changes in the participants list and the connected streams.
enum ConferenceServiceEventNames implements EnumWithStringValue {
  /// Emitted when a new participant is invited to a conference. The SDK does not emit the participantAdded event for the local participant. Listeners only receive the participantAdded events about users; they do not receive events for other listeners. Users receive the participantAdded events about users and do not receive any events about listeners.
  participantAdded('EVENT_CONFERENCE_PARTICIPANT_ADDED'),

  /// Emitted when a conference participant changes status. Listeners only receive the participantUpdated events about users; they do not receive events for other listeners. Users receive the participantUpdated events about users and do not receive any events about listeners.
  participantUpdated('EVENT_CONFERENCE_PARTICIPANT_UPDATED'),

  /// Emitted when the local participant's permissions are updated.
  permissionsUpdated('EVENT_CONFERENCE_PERMISSIONS_UPDATED'),

  /// Emitted when a conference status has changed.
  statusUpdated('EVENT_CONFERENCE_STATUS_UPDATED'),

  /// Emitted when the SDK adds a new stream to a conference participant. Each conference participant can be connected to two streams: the audio and video stream and the screen-share stream. If a participant enables audio or video, the SDK adds the audio and video stream to the participant and emits the streamAdded event to all participants. When a participant is connected to the audio and video stream and changes the stream, for example, enables a camera while using a microphone, the SDK updates the audio and video stream and emits the [streamUpdated] event. When a participant starts sharing a screen, the SDK adds the screen-share stream to this participants and emits the streamAdded event to all participants. The following graphic shows this behavior:
  ///
  /// <img src="https://files.readme.io/21575c1-conference-stream-added.png" width="700">
  ///
  /// Based on the stream type, the application chooses to either render a camera view or a screen-share view.
  /// When a new participant joins a conference with enabled audio and video, the SDK emits the streamAdded event that contains audio and video tracks.
  /// The SDK can also emit the streamAdded event only for the local participant. When the local participant uses the [ConferenceService.stopAudio] method to locally mute the selected remote participant who does not use a camera, the local participant receives the [streamRemoved] event. After using the [ConferenceService.startAudio] method for this remote participant, the local participant receives the streamAdded event.
  streamAdded('EVENT_CONFERENCE_STREAM_ADDED'),

  /// Emitted when a conference participant who is connected to the audio and video stream changes the stream by enabling a microphone while using a camera or by enabling a camera while using a microphone. The event is emitted to all conference participants. The following graphic shows this behavior:
  ///
  /// <img src="https://files.readme.io/21575c1-conference-stream-added.png" width="700">
  ///
  /// The SDK can also emit the streamUpdated event only for the local participant. When the local participant uses the [ConferenceService.stopAudio] or [ConferenceService.startAudio] method to locally mute or un-mute a selected remote participant who uses a camera, the local participant receives the streamUpdated event.
  streamUpdated('EVENT_CONFERENCE_STREAM_UPDATED'),

  /// Emitted when the SDK removes a stream from a conference participant. Each conference participant can be connected to two streams: the audio and video stream and the screen-share stream. If a participant disables audio and video or stops a screen-share presentation, the SDK removes the proper stream and emits the streamRemoved event to all conference participants.
  /// The SDK can also emit the streamRemoved event only for the local participant. When the local participant uses the [ConferenceService.stopAudio] method to locally mute a selected remote participant who does not use a camera, the local participant receives the streamRemoved event.
  streamRemoved('EVENT_CONFERENCE_STREAM_REMOVED');

  @override
  final String value;

  const ConferenceServiceEventNames(this.value);

  static ConferenceServiceEventNames valueOf(String? value) {
    final event = ConferenceServiceEventNames.values.firstWhereOrNull((element) => element.value == value);
    if (event == null) {
      throw "Could not create ConferenceServiceEventNames from string: $value";
    }
    return event;
  }
}

/// The AudioProcessingOptions class is responsible for enabling and disabling audio processing.
class AudioProcessingOptions {
  /// Allows enabling and disabling audio processing for the local participant who transmits an audio stream.
  AudioProcessingSenderOptions? send;

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "send": send?.toJson(),
      };
}

/// The AudioProcessingSenderOptions class allows enabling and disabling audio processing for the local participant who transmits an audio stream.
class AudioProcessingSenderOptions {
  /// A boolean that indicates whether audio processing should be enabled or disabled.
  bool? audioProcessing;

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
        "audioProcessing": audioProcessing,
      };
}

enum VideoForwardingStrategy {
  lastSpeaker('LAST_SPEAKER'),
  closestUser('CLOSEST_USER');

  final String _value;

  const VideoForwardingStrategy(this._value);

  static VideoForwardingStrategy decode(String value) {
    return VideoForwardingStrategy.values.firstWhere(
      (element) => element._value == value,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }

  String encode() {
    return _value;
  }
}
