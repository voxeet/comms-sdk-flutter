import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/conference_service.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/conference.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant_info.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/spatial.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/session_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';
import '../test_helpers.dart';
import 'dolbyio_comms_conference_service_test.mocks.dart';

var participant = Participant("my_id", ParticipantInfo("test", null, null),
    ParticipantStatus.connected, ParticipantType.user);
var participantMap = {
  "id": "my_id",
  "info": {
    "name": "test",
    "avatarUrl": null,
    "externalId": null,
  },
  "status": ParticipantStatus.connected.encode(),
  "type": ParticipantType.user.encode(),
  "streams": null,
};

var participants = [participant];
<<<<<<< HEAD
<<<<<<< HEAD
var conference = Conference("test_conf", "test_id", true, participants,
    ConferenceStatus.joined, SpatialAudioStyle.individual);
=======
var conference = Conference(
    "test_conf", "test_id", true, participants, ConferenceStatus.joined, SpatialAudioStyle.individual);
>>>>>>> 7c170e6 (Add SpatialAudioStyle in iOS (#187))
=======
var conference = Conference("test_conf", "test_id", true, participants,
    ConferenceStatus.joined, SpatialAudioStyle.individual);
>>>>>>> f36ccda (Merge release/3.6.1 to develop (#209))
var conferenceMap = {
  "alias": "test_conf",
  "id": "test_id",
  "isNew": true,
  "participants": participants.map((e) => e.toJson()).toList(),
  "status": ConferenceStatus.joined.encode(),
  "spatialAudioStyle": SpatialAudioStyle.individual.encode()
};

@GenerateMocks([SessionService])
void main() {
  var sessionService = MockSessionService();
  var conferenceService = ConferenceService(sessionService);
  final MethodChannel channel =
      DolbyioCommsSdkFlutterPlatform.createMethodChannel("conference_service");

  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test create method", () async {
    var createParams = ConferenceCreateParameters()
      ..dolbyVoice = true
      ..liveRecording = true
      ..rtcpMode = RTCPMode.best
      ..ttl = 1000
      ..videoCodec = Codec.h264;
<<<<<<< HEAD
<<<<<<< HEAD
    var createOptions = ConferenceCreateOption(
        "conference", createParams, 1, SpatialAudioStyle.individual);
=======
    var createOptions = ConferenceCreateOption("conference", createParams, 1, SpatialAudioStyle.individual);
>>>>>>> 7c170e6 (Add SpatialAudioStyle in iOS (#187))
=======
    var createOptions = ConferenceCreateOption(
        "conference", createParams, 1, SpatialAudioStyle.individual);
>>>>>>> f36ccda (Merge release/3.6.1 to develop (#209))
    when(channel.invokeMethod("create", createOptions.toJson()))
        .thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.create(createOptions);

    expectConference(result, conference);
    verify(channel.invokeMethod("create", {
      "alias": "conference",
      "params": {
        "dolbyVoice": true,
        "liveRecording": true,
        "rtcpMode": RTCPMode.best.encode(),
        "ttl": 1000,
        "videoCodec": Codec.h264.encode(),
      },
      "pinCode": 1,
      "spatialAudioStyle": "INDIVIDUAL"
    })).called(1);
  });

  test("test current method", () async {
    when(channel.invokeMethod("current"))
        .thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.current();

    expectConference(result, conference);
    verify(channel.invokeMethod("current")).called(1);
  });

  test("test fetch method", () async {
    when(channel.invokeMethod("fetch", {"conferenceId": conference.id}))
        .thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.fetch(conference.id);

    expectConference(result, conference);
    verify(channel.invokeMethod("fetch", {"conferenceId": "test_id"}))
        .called(1);
  });

  test("test getAudioLevel method", () async {
    when(channel.invokeMethod("getAudioLevel", participant.toJson()))
        .thenAnswer((_) => Future.value(1.0));

    var result = await conferenceService.getAudioLevel(participant);

    expect(result, 1.0);
    verify(channel.invokeMethod("getAudioLevel", participantMap)).called(1);
  });

  test("test join method", () async {
    var joinOptions = ConferenceJoinOptions()
      ..conferenceAccessToken = "token"
      ..constraints = ConferenceConstraints(true, true)
      ..maxVideoForwarding = 2
      ..mixing = ConferenceMixingOptions(true)
      ..videoForwardingStrategy = VideoForwardingStrategy.closestUser
      ..simulcast = true
      ..spatialAudio = true;

    when(channel.invokeMethod("join", {
      "conference": conference.toJson(),
      "options": joinOptions.toJson()
    })).thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.join(conference, joinOptions);

    expectConference(result, conference);
    verify(channel.invokeMethod("join", {
      "conference": conferenceMap,
      "options": {
        "constraints": joinOptions.constraints?.toJson(),
        "conferenceAccessToken": joinOptions.conferenceAccessToken,
        "maxVideoForwarding": joinOptions.maxVideoForwarding,
        "mixing": joinOptions.mixing?.toJson(),
        "videoForwardingStrategy": joinOptions.videoForwardingStrategy?.encode(),
        "simulcast": joinOptions.simulcast,
        "spatialAudio": joinOptions.spatialAudio,
      }
    })).called(1);
  });

  test("test listen method", () async {
    var joinOptions = ConferenceListenOptions()
      ..conferenceAccessToken = "token"
      ..maxVideoForwarding = 2
      ..videoForwardingStrategy = VideoForwardingStrategy.closestUser
      ..spatialAudio = true;

    when(channel.invokeMethod("listen", {
      "conference": conference.toJson(),
      "options": joinOptions.toJson()
    })).thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.listen(conference, joinOptions);

    expectConference(result, conference);
    verify(channel.invokeMethod("listen", {
      "conference": conferenceMap,
      "options": {
        "conferenceAccessToken": joinOptions.conferenceAccessToken,
        "maxVideoForwarding": joinOptions.maxVideoForwarding,
        "videoForwardingStrategy": joinOptions.videoForwardingStrategy?.encode(),
        "spatialAudio": joinOptions.spatialAudio,
      }
    })).called(1);
  });

  test("test leave method with leaveRoom option set to true", () async {
    var leaveOptions = ConferenceLeaveOptions(true);
    when(channel.invokeMethod("leave")).thenAnswer((_) => Future.value());
    when(sessionService.close()).thenAnswer((_) => Future.value());

    await conferenceService.leave(options: leaveOptions);

    verify(sessionService.close()).called(1);
    verify(channel.invokeMethod("leave")).called(1);
  });

  test("test leave method with leaveRoom option set to false", () async {
    var leaveOptions = ConferenceLeaveOptions(false);
    when(channel.invokeMethod("leave")).thenAnswer((_) => Future.value());
    when(sessionService.close()).thenAnswer((_) => Future.value());

    await conferenceService.leave(options: leaveOptions);

    verifyNever(sessionService.close());
    verify(channel.invokeMethod("leave")).called(1);
  });

  test("test leave method without leave options", () async {
    when(channel.invokeMethod("leave")).thenAnswer((_) => Future.value());

    await conferenceService.leave();

    verifyNever(sessionService.close());
    verify(channel.invokeMethod("leave")).called(1);
  });

  test("test kick method", () async {
    when(channel.invokeMethod("kick", participant.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.kick(participant);

    verify(channel.invokeMethod("kick", participantMap)).called(1);
  });

  test("test getParticipants method", () async {
    when(channel.invokeMethod("getParticipants", conference.toJson()))
        .thenAnswer(
            (_) => Future.value(participants.map((e) => e.toJson()).toList()));

    var result = await conferenceService.getParticipants(conference);

    expectParticipant(result.first, participants.first);
    verify(channel.invokeMethod("getParticipants", conferenceMap)).called(1);
  });

  test("test mute method", () async {
    when(channel.invokeMethod(
            "mute", {"isMuted": true, "participant": participant.toJson()}))
        .thenAnswer((_) => Future.value(true));

    var result = await conferenceService.mute(participant, true);

    expect(result, true);
    verify(channel.invokeMethod("mute", {
      "isMuted": true,
      "participant": participantMap,
    })).called(1);
  });

  test("test muteOutput method", () async {
    when(channel.invokeMethod("muteOutput", {"isMuted": true}))
        .thenAnswer((_) => Future.value(true));

    var result = await conferenceService.muteOutput(true);

    expect(result, true);
    verify(channel.invokeMethod("muteOutput", {"isMuted": true})).called(1);
  });

  test("test isMuted method", () async {
    when(channel.invokeMethod("isMuted")).thenAnswer((_) => Future.value(true));

    var result = await conferenceService.isMuted();

    expect(result, true);
    verify(channel.invokeMethod("isMuted")).called(1);
  });

  test("test setSpatialPosition method", () async {
    var position = SpatialPosition(1.0, 2.0, 3.0);
    when(channel.invokeMethod("setSpatialPosition", {
      "position": position.toJson(),
      "participant": participant.toJson(),
    })).thenAnswer((_) => Future.value());

    await conferenceService.setSpatialPosition(
        participant: participant, position: position);

    verify(channel.invokeMethod("setSpatialPosition", {
      "position": {"x": 1.0, "y": 2.0, "z": 3.0},
      "participant": participantMap
    })).called(1);
  });

  test("test startAudio method", () async {
    when(channel.invokeMethod("startAudio", participant.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.startAudio(participant);

    verify(channel.invokeMethod("startAudio", participantMap)).called(1);
  });

  test("test startVideo method", () async {
    when(channel.invokeMethod("startVideo", participant.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.startVideo(participant);

    verify(channel.invokeMethod("startVideo", participantMap)).called(1);
  });

  test("test stopAudio method", () async {
    when(channel.invokeMethod("stopAudio", participant.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.stopAudio(participant);

    verify(channel.invokeMethod("stopAudio", participantMap)).called(1);
  });

  test("test stopVideo method", () async {
    when(channel.invokeMethod("stopVideo", participant.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.stopVideo(participant);

    verify(channel.invokeMethod("stopVideo", participantMap)).called(1);
  });

  test("test startScreenShare method", () async {
    when(channel.invokeMethod("startScreenShare"))
        .thenAnswer((_) => Future.value());

    await conferenceService.startScreenShare();

    verify(channel.invokeMethod("startScreenShare")).called(1);
  });

  test("test stopScreenShare method", () async {
    when(channel.invokeMethod("stopScreenShare"))
        .thenAnswer((_) => Future.value());

    await conferenceService.stopScreenShare();

    verify(channel.invokeMethod("stopScreenShare")).called(1);
  });

  test("test setSpatialDirection method", () async {
    var direction = SpatialDirection(1.0, 2.0, 3.0);
    when(channel.invokeMethod("setSpatialDirection", direction.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.setSpatialDirection(direction);

    verify(channel.invokeMethod(
        "setSpatialDirection", {"x": 1.0, "y": 2.0, "z": 3.0})).called(1);
  });

  test("test setSpatialEnvironment method", () async {
    var scale = SpatialScale(1.0, 1.0, 1.0);
    var forward = SpatialPosition(0.0, 1.0, 0.0);
    var up = SpatialPosition(0.0, 0.0, 1.0);
    var right = SpatialPosition(1.0, 0.0, 0.0);
    when(channel.invokeMethod(
      "setSpatialEnvironment",
      {
        "scale": scale.toJson(),
        "forward": forward.toJson(),
        "up": up.toJson(),
        "right": right.toJson(),
      },
    )).thenAnswer((_) => Future.value());

    await conferenceService.setSpatialEnvironment(scale, forward, up, right);

    verify(channel.invokeMethod(
      "setSpatialEnvironment",
      {
        "scale": {"x": 1.0, "y": 1.0, "z": 1.0},
        "forward": {"x": 0.0, "y": 1.0, "z": 0.0},
        "up": {"x": 0.0, "y": 0.0, "z": 1.0},
        "right": {"x": 1.0, "y": 0.0, "z": 0.0},
      },
    )).called(1);
  });

  test("test isSpeaking method", () async {
    when(channel.invokeMethod("isSpeaking", participant.toJson()))
        .thenAnswer((_) => Future.value(true));

    var result = await conferenceService.isSpeaking(participant);

    expect(result, true);
    verify(channel.invokeMethod("isSpeaking", participantMap)).called(1);
  });

  test("test getStatus method", () async {
    when(channel.invokeMethod("getStatus", conference.toJson()))
        .thenAnswer((_) => Future.value('JOINED'));

    var result = await conferenceService.getStatus(conference);

    expect(result, ConferenceStatus.joined);
    verify(channel.invokeMethod("getStatus", conferenceMap)).called(1);
  });

  test("test getMaxVideoForwarding method", () async {
    when(channel.invokeMethod("getMaxVideoForwarding"))
        .thenAnswer((_) => Future.value(3));

    var result = await conferenceService.getMaxVideoForwarding();

    expect(result, 3);
    verify(channel.invokeMethod("getMaxVideoForwarding")).called(1);
  });

  test("test setMaxVideoForwarding method", () async {
    var maxVideoForwarding = 3;
    when(channel.invokeMethod("setMaxVideoForwarding", {
      "max": maxVideoForwarding,
      "prioritizedParticipants": [participant.toJson()],
    })).thenAnswer((_) => Future.value(true));

    var result = await conferenceService
        // ignore: deprecated_member_use_from_same_package
        .setMaxVideoForwarding(maxVideoForwarding, [participant]);

    expect(result, true);
    verify(channel.invokeMethod("setMaxVideoForwarding", {
      "max": maxVideoForwarding,
      "prioritizedParticipants": [participantMap],
    })).called(1);
  });

  test("test setVideoForwarding method", () async {
    var strategy = VideoForwardingStrategy.closestUser;
    var maxVideoForwarding = 3;
    when(channel.invokeMethod("setVideoForwarding", {
      "strategy": 'CLOSEST_USER',
      "max": maxVideoForwarding,
      "prioritizedParticipants": [participant.toJson()],
    })).thenAnswer((_) => Future.value(true));

    var result = await conferenceService
        .setVideoForwarding(strategy, maxVideoForwarding, [participant]);

    expect(result, true);
    verify(channel.invokeMethod("setVideoForwarding", {
      "strategy": 'CLOSEST_USER',
      "max": maxVideoForwarding,
      "prioritizedParticipants": [participantMap],
    })).called(1);
  });

  test("test getParticipant method", () async {
    when(channel.invokeMethod(
      "getParticipant",
      {"participantId": "my_id"},
    )).thenAnswer((_) => Future.value(participant.toJson()));

    var result = await conferenceService.getParticipant("my_id");

    expectParticipant(result, participant);
    verify(channel.invokeMethod("getParticipant", {"participantId": "my_id"}))
        .called(1);
  });

  test("test replay method", () async {
    var replayOptions = ConferenceReplayOptions("token", 100);
    when(channel.invokeMethod("replay", {
      "conference": conference.toJson(),
      "offset": replayOptions.offset,
      "conferenceAccessToken": replayOptions.conferenceAccessToken
    })).thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.replay(
        conference: conference, replayOptions: replayOptions);

    expectConference(result, conference);
    verify(channel.invokeMethod("replay", {
      "conference": conferenceMap,
      "offset": 100,
      "conferenceAccessToken": "token"
    })).called(1);
  });

  test("test replay method without replay options", () async {
    when(channel.invokeMethod("replay", {
      "conference": conference.toJson(),
      "offset": null,
      "conferenceAccessToken": null
    })).thenAnswer((_) => Future.value(conference.toJson()));

    var result = await conferenceService.replay(conference: conference);

    expectConference(result, conference);
    verify(channel.invokeMethod("replay", {
      "conference": conferenceMap,
      "offset": null,
      "conferenceAccessToken": null
    })).called(1);
  });

  test("test setAudioProcessing method", () async {
    var senderOptions = AudioProcessingSenderOptions()..audioProcessing = true;
    var options = AudioProcessingOptions()..send = senderOptions;
    when(channel.invokeMethod("setAudioProcessing", options.toJson()))
        .thenAnswer((_) => Future.value());

    await conferenceService.setAudioProcessing(options);

    verify(channel.invokeMethod("setAudioProcessing", {
      "send": {"audioProcessing": true}
    })).called(1);
  });

  test("test updatePermissions method", () async {
    var permissions = [
      ParticipantPermissions(participant, [ConferencePermission.sendAudio])
    ];
    when(channel.invokeMethod(
            "updatePermissions", permissions.map((e) => e.toJson()).toList()))
        .thenAnswer((_) => Future.value());

    await conferenceService.updatePermissions(permissions);

    verify(channel.invokeMethod("updatePermissions", [
      {
        "participant": participantMap,
        "permissions": ['SEND_AUDIO']
      }
    ])).called(1);
  });
}
