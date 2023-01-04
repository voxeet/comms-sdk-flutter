import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';

void recordingServiceTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });
  
  group('Recording Service', () {
    if (Platform.isIOS) {
      testWidgets('RecordingService: currentRecording', (tester) async {
        await runNative(
            methodChannel: recordingServiceAssertsMethodChannel,
            label: "setCurrentRecording",
            args: {"status": 1, "participantId": "123", "startTimestamp": 1});

        var current =
            await dolbyioCommsSdkFlutterPlugin.recording.currentRecording();
        expect(current.participantId, "123");
        expect(current.startTimestamp, 1);
        expect(current.recordingStatus, RecordingStatus.recording);
      });
    }

    testWidgets('RecordingService: start', (tester) async {
      await dolbyioCommsSdkFlutterPlugin.recording.start();
      await expectNative(
          methodChannel: recordingServiceAssertsMethodChannel,
          assertLabel: "assertStartRecordingArgs",
          expected: {"hasRun": true});
    });

    testWidgets('RecordingService: stop', (tester) async {
      await dolbyioCommsSdkFlutterPlugin.recording.stop();
      await expectNative(
          methodChannel: recordingServiceAssertsMethodChannel,
          assertLabel: "assertStopRecordingArgs",
          expected: {"hasRun": true});
    });
  });
}
