import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'token.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  var tokenString = "";

  setUp(() async {
    tokenString = token;
  });

  testWidgets('VoxeetSDK: initiliseToken', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.initializeToken(
        tokenString, () => Future.value(tokenString));
  });

  testWidgets('VoxeetSDK: openSession', (tester) async {
    var participantInfo = ParticipantInfo("participant_1", "avatarUrl", "123");
    await dolbyioCommsSdkFlutterPlugin.session.open(participantInfo);

    expect(participantInfo.name, "participant_1");

    participantInfo = ParticipantInfo("participant_2", "avatarUrl", "345");
    await dolbyioCommsSdkFlutterPlugin.session.open(participantInfo);

    expect(participantInfo.name, "participant_2");
  });

  testWidgets('VoxeetSDK: createJoin', (tester) async {
    var parameters = ConferenceCreateParameters();
    parameters.dolbyVoice = true;
    parameters.liveRecording = true;
    parameters.rtcpMode = RTCPMode.best;
    parameters.ttl = 15;
    parameters.videoCodec = Codec.h264;
    var options = ConferenceCreateOption(
        "test", parameters, 123, SpatialAudioStyle.individual);

    var conference =
        await dolbyioCommsSdkFlutterPlugin.conference.create(options);

    expect(conference.status.name, "created");

    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);
    joinOptions.maxVideoForwarding = 4;
    joinOptions.spatialAudio = true;
    joinOptions.mixing = ConferenceMixingOptions(true);
    await dolbyioCommsSdkFlutterPlugin.conference.join(conference, joinOptions);

    var participant = await dolbyioCommsSdkFlutterPlugin.conference
        .getParticipants(conference);

    expect(participant[0].info?.name, "participant_1");

    await dolbyioCommsSdkFlutterPlugin.conference.mute(participant[0], true);

    var isMuted = await dolbyioCommsSdkFlutterPlugin.conference.isMuted();

    expect(isMuted, true);

    await dolbyioCommsSdkFlutterPlugin.conference.setSpatialPosition(
        participant: participant[0], position: SpatialPosition(1, 1, 1));

    await dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialDirection(SpatialDirection(1, 1, 1));

    var leaveOptions = ConferenceLeaveOptions(true);
    await dolbyioCommsSdkFlutterPlugin.conference.leave(options: leaveOptions);
  });
}
