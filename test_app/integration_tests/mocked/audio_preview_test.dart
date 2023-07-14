import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';
import '../utils.dart';

void audioPreviewTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });

  group('Audio Preview', () {
    testWidgets('AudioPreview: status', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "getStatus"
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.status();

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertStatusArgs",
          expected: {"hasRun": true});
    });

    testWidgets('AudioPreview: getCaptureMode', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "getCaptureMode"
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.getCaptureMode();

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertGetCaptureModeArgs",
          expected: {"hasRun": true});
    });

    testWidgets('AudioPreview: setCaptureMode', (tester) async {
      var testCaptureMode = AudioCaptureOptions(AudioCaptureMode.standard, NoiseReduction.high, voiceFont: VoiceFont.brokenRobot);
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "setCaptureMode",
          args: testCaptureMode.toJson()
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.setCaptureMode(testCaptureMode);

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertSetCaptureModeArgs",
          expected: testCaptureMode.toJson());
    });

    testWidgets('AudioPreview: record', (tester) async {
      var duration = 5;
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "record",
          args: { "duration": duration }
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.record(duration);

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertRecordArgs",
          expected: {"duration": duration});
    });

    testWidgets('AudioPreview: play', (tester) async {
      var loop = false;
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "play",
          args: { "loop": loop }
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.play(loop);

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertPlayArgs",
          expected: {"loop": loop});
    });

    testWidgets('AudioPreview: cancel', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "cancel"
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.cancel();

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertCancelArgs",
          expected: {"hasRun": true});
    });

    testWidgets('AudioPreview: release', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "release"
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.release();

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertReleaseArgs",
          expected: {"hasRun": true});
    });
  });
}