import 'dart:io';

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

  testWidgets('VideoPresentationService: start', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoPresentation
        .start('https://dolby.io/video_url');
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStartArgs",
        expected: {"hasRun": true, "url": 'https://dolby.io/video_url'});
  });

  testWidgets('VideoPresentationService: stop', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoPresentation.stop();
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStopArgs",
        expected: {"hasRun": true});
  });

  testWidgets('VideoPresentationService: play', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoPresentation.play();
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertPlayArgs",
        expected: {"hasRun": true});
  });

  testWidgets('VideoPresentationService: pause', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoPresentation.pause(1);
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertPauseArgs",
        expected: {"hasRun": true, "timestamp": 1});
  });

  testWidgets('VideoPresentationService: seek', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoPresentation.seek(1);
    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertSeekArgs",
        expected: {"hasRun": true, "timestamp": 1});
  });

  testWidgets('VideoPresentationService: state', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.videoPresentation.play();
    var statePlay =
        await dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
    expect(statePlay, VideoPresentationState.play);

    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStateArgs",
        expected: {"hasRun": true, "state": 1});

    await resetSDK();

    if (!Platform.isAndroid) {
      await dolbyioCommsSdkFlutterPlugin.videoPresentation.stop();
      var stateStop =
      await dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
      expect(stateStop, VideoPresentationState.stopped);

      await expectNative(
          methodChannel: videoPresentationServiceAssertsMethodChannel,
          assertLabel: "assertStateArgs",
          expected: {"hasRun": true, "state": 0});

      await resetSDK();
    }

    await dolbyioCommsSdkFlutterPlugin.videoPresentation.pause(0);
    var statePause =
        await dolbyioCommsSdkFlutterPlugin.videoPresentation.state();
    expect(statePause, VideoPresentationState.paused);

    await expectNative(
        methodChannel: videoPresentationServiceAssertsMethodChannel,
        assertLabel: "assertStateArgs",
        expected: {"hasRun": true, "state": 2});
  });
}
