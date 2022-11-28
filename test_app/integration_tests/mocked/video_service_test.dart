import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';
import '../utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });

  testWidgets('LocalVideoService: start', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoService.localVideo.start();

    await expectNative(
        methodChannel: videoServiceAssertsMethodChannel,
        assertLabel: "assertLocalStartArgs",
        expected: {"hasRun": true});
  });

  testWidgets('LocalVideoService: stop', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoService.localVideo.stop();

    await expectNative(
        methodChannel: videoServiceAssertsMethodChannel,
        assertLabel: "assertLocalStopArgs",
        expected: {"hasRun": true});
  });

  testWidgets('RemoteVideoService: start', (tester) async {
    var participant = Participant(
        "participant_id_5_1",
        ParticipantInfo("participant_name", "avatar_url", "external_id"),
        ParticipantStatus.connected,
        ParticipantType.listner);

    runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setCurrentConference",
        args: {"type": 5});

    await dolbyioCommsSdkFlutterPlugin.videoService.remoteVideo
        .start(participant);

    await expectNative(
        methodChannel: videoServiceAssertsMethodChannel,
        assertLabel: "assertRemoteStartArgs",
        expected: {"id": "participant_id_5_1"});
  });

  testWidgets('RemoteVideoService: stop', (tester) async {
    var participant = Participant(
        "participant_id_5_1",
        ParticipantInfo("participant_name", "avatar_url", "external_id"),
        ParticipantStatus.connected,
        ParticipantType.listner);

    runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setCurrentConference",
        args: {"type": 5});

    await dolbyioCommsSdkFlutterPlugin.videoService.remoteVideo
        .stop(participant);

    await expectNative(
        methodChannel: videoServiceAssertsMethodChannel,
        assertLabel: "assertRemoteStopArgs",
        expected: {"id": "participant_id_5_1"});
  });
}
