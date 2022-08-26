import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });

  testWidgets('VideoPresentationService: start', (tester) async {
    dolbyioCommsSdkFlutterPlugin.videoPresentation
        .start('https://dolby.io/video_url');
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStartArgs",
        expected: {"hasRun": true, "url": 'https://dolby.io/video_url'});
  });

  testWidgets('VideoPresentationService: stop', (tester) async {
    dolbyioCommsSdkFlutterPlugin.videoPresentation.stop();
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStopArgs",
        expected: {"hasRun": true});
  });

  testWidgets('VideoPresentationService: play', (tester) async {
    dolbyioCommsSdkFlutterPlugin.videoPresentation.play();
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertPlayArgs",
        expected: {"hasRun": true});
  });

  testWidgets('VideoPresentationService: pause', (tester) async {
    dolbyioCommsSdkFlutterPlugin.videoPresentation.pause(1);
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertPauseArgs",
        expected: {"hasRun": true, "timestamp": 1});
  });

  testWidgets('VideoPresentationService: seek', (tester) async {
    dolbyioCommsSdkFlutterPlugin.videoPresentation.seek(1);
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertSeekArgs",
        expected: {"hasRun": true, "timestamp": 1});
  });

  testWidgets('VideoPresentationService: state', (tester) async {
    dolbyioCommsSdkFlutterPlugin.videoPresentation.play();
    var statePlay =
        await dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
    expect(statePlay, VideoPresentationState.PLAY);

    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStateArgs",
        expected: {"hasRun": true, "state": 1});

    await resetSDK();

    dolbyioCommsSdkFlutterPlugin.videoPresentation.stop();
    var stateStop =
        await dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
    expect(stateStop, VideoPresentationState.STOPPED);

    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStateArgs",
        expected: {"hasRun": true, "state": 0});

    await resetSDK();

    dolbyioCommsSdkFlutterPlugin.videoPresentation.pause(0);
    var statePause =
        await dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
    expect(statePause, VideoPresentationState.PAUSED);

    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStateArgs",
        expected: {"hasRun": true, "state": 2});
  });
}
