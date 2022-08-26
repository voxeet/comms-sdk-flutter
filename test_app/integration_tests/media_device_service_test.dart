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

  testWidgets('MediaDeviceService: getComfortNoiseLevel', (tester) async {
    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Default);
    var noiseLevelDefault =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelDefault, ComfortNoiseLevel.Default);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 0, "hasRun": true});

    await resetSDK();

    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Low);
    var noiseLevelLow =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelLow, ComfortNoiseLevel.Low);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 1, "hasRun": true});

    await resetSDK();

    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Medium);
    var noiseLevelMedium =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelMedium, ComfortNoiseLevel.Medium);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 2, "hasRun": true});

    await resetSDK();

    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Off);
    var noiseLevelOff =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelOff, ComfortNoiseLevel.Off);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 3, "hasRun": true});
  });

  testWidgets('MediaDeviceService: setComfortNoiseLevel', (tester) async {
    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Default);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 0});

    await resetSDK();

    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Low);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 1});

    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Medium);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 2});

    dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.Off);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 3});
  });

  testWidgets('MediaDeviceService: switchCamera', (tester) async {
    dolbyioCommsSdkFlutterPlugin.mediaDevice.switchCamera();
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSwitchCameraArgs",
        expected: {"hasRun": true});
  });

  testWidgets('MediaDeviceService: switchDeviceSpeaker', (tester) async {
    dolbyioCommsSdkFlutterPlugin.mediaDevice.switchSpeaker();
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSwitchDeviceSpeakerArgs",
        expected: {"hasRun": true});
  });
}