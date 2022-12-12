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

  testWidgets('LocalAudioService: start', (tester) async {
    runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setCurrentConference",
        args: {"type": 5});

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.start();

    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertLocalStartArgs",
        expected: {"hasRun": true});
  });

  testWidgets('LocalAudioService: stop', (tester) async {
    runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setCurrentConference",
        args: {"type": 5});

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.stop();

    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertLocalStopArgs",
        expected: {"hasRun": true});
  });

  testWidgets('LocalAudioService: getComfortNoiseLevel', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.defaultLevel);
    var noiseLevelDefault = await dolbyioCommsSdkFlutterPlugin
        .audioService.localAudio
        .getComfortNoiseLevel();
    expect(noiseLevelDefault, ComfortNoiseLevel.defaultLevel);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 0, "hasRun": true});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.low);
    var noiseLevelLow = await dolbyioCommsSdkFlutterPlugin
        .audioService.localAudio
        .getComfortNoiseLevel();
    expect(noiseLevelLow, ComfortNoiseLevel.low);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 1, "hasRun": true});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.medium);
    var noiseLevelMedium = await dolbyioCommsSdkFlutterPlugin
        .audioService.localAudio
        .getComfortNoiseLevel();
    expect(noiseLevelMedium, ComfortNoiseLevel.medium);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 2, "hasRun": true});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.off);
    var noiseLevelOff = await dolbyioCommsSdkFlutterPlugin
        .audioService.localAudio
        .getComfortNoiseLevel();
    expect(noiseLevelOff, ComfortNoiseLevel.off);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 3, "hasRun": true});
  });

  testWidgets('LocalAudioService: setComfortNoiseLevel', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.defaultLevel);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 0});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.low);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 1});

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.medium);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 2});

    await dolbyioCommsSdkFlutterPlugin.audioService.localAudio
        .setComfortNoiseLevel(ComfortNoiseLevel.off);
    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 3});
  });

  testWidgets('RemotAudioService: start', (tester) async {
    var participant = Participant(
        "participant_id_5_1",
        ParticipantInfo("participant_name", "avatar_url", "external_id"),
        ParticipantStatus.connected,
        ParticipantType.listner);

    runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setCurrentConference",
        args: {"type": 5});

    await dolbyioCommsSdkFlutterPlugin.audioService.remoteAudio
        .start(participant);

    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertRemoteStartArgs",
        expected: {"id": "participant_id_5_1"});
  });

  testWidgets('RemoteAudioService: stop', (tester) async {
    var participant = Participant(
        "participant_id_5_1",
        ParticipantInfo("participant_name", "avatar_url", "external_id"),
        ParticipantStatus.connected,
        ParticipantType.listner);

    runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setCurrentConference",
        args: {"type": 5});

    await dolbyioCommsSdkFlutterPlugin.audioService.remoteAudio
        .stop(participant);

    await expectNative(
        methodChannel: audioServiceAssertsMethodChannel,
        assertLabel: "assertRemoteStopArgs",
        expected: {"id": "participant_id_5_1"});
  });
}
