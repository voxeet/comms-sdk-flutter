import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';
import '../utils.dart';

void audioPreviewTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });

  group('Audio Preview', () {

    testWidgets('AudioPreview: status', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "getStatus");

      for (final nativieStatus in recorderStatuses) {
        final status = await dolbyioCommsSdkFlutterPlugin
            .audioService.localAudio.preview
            .status();
        expect(status, equals(nativieStatus));
      }
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

      var captureMode = await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.getCaptureMode();
      expect(captureMode.mode, equals(AudioCaptureMode.unprocessed));

      for (final voiceFont in voiceFonts) {
        for (final noiseReduction in noiseReductions) {
          captureMode = await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.getCaptureMode();
          expect(captureMode.mode, equals(AudioCaptureMode.standard));
          expect(captureMode.noiseReduction, equals(noiseReduction));
          expect(captureMode.voiceFont, equals(voiceFont));
        }
      }

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertGetCaptureModeArgs",
          expected: {"hasRun": true});
    });

    testWidgets('AudioPreview: setCaptureMode', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "setCaptureMode",
      );

      var testCaptureMode =
          AudioCaptureOptions(AudioCaptureMode.unprocessed, null);
      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
          .setCaptureMode(testCaptureMode);

      for (final voiceFont in voiceFonts) {
        for (final noiseReduction in noiseReductions) {
          testCaptureMode = AudioCaptureOptions(
              AudioCaptureMode.standard, noiseReduction,
              voiceFont: voiceFont);
          await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview
              .setCaptureMode(testCaptureMode);
        }
      }

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertSetCaptureModeArgs",
          expected: {});
    });

    testWidgets('AudioPreview: record', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "record"
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.record(1);
      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.record(10);

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertRecordArgs",
          expected: {});
    });

    testWidgets('AudioPreview: play', (tester) async {
      runNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          label: "play",
      );

      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.play(true);
      await dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.play(false);

      await expectNative(
          methodChannel: audioPreviewAssertsMethodChannel,
          assertLabel: "assertPlayArgs",
          expected: {});
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

    testWidgets('AudioPreview: onStatusChange', (tester) async {

      await runNative(
        methodChannel: audioPreviewAssertsMethodChannel,
        label: "emitStatusChangedEvents",
        args: { });

      List<Event<AudioPreviewEventNames, RecorderStatus>> receivedEvents = [];
      await for (final event in dolbyioCommsSdkFlutterPlugin.audioService.localAudio.preview.onStatusChanged()) {
        receivedEvents.add(event);
        if (receivedEvents.length >= recorderStatuses.length) {
          break;
        }
      }

      for (var i = 0; i < recorderStatuses.length; i++) {
        expect(recorderStatuses[i], receivedEvents[i].body);
      }
    });
  });
}

const recorderStatuses = [
  RecorderStatus.noRecordingAvailable,
  RecorderStatus.recordingAvailable,
  RecorderStatus.recording,
  RecorderStatus.playing,
  RecorderStatus.released
];

final voiceFonts = [
  VoiceFont.none,
  VoiceFont.masculine,
  VoiceFont.feminine,
  VoiceFont.helium,
  VoiceFont.darkModulation,
  VoiceFont.brokenRobot,
  VoiceFont.interference,
  VoiceFont.abyss,
  VoiceFont.wobble,
  VoiceFont.starshipCaptain,
  VoiceFont.nervousRobot,
  VoiceFont.swarm,
  VoiceFont.amRadio,
];

final noiseReductions = [NoiseReduction.high, NoiseReduction.low];
