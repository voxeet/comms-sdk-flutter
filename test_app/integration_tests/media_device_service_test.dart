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
    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.defaultLevel);
    var noiseLevelDefault =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelDefault, ComfortNoiseLevel.defaultLevel);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 0, "hasRun": true});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.low);
    var noiseLevelLow =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelLow, ComfortNoiseLevel.low);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 1, "hasRun": true});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.medium);
    var noiseLevelMedium =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelMedium, ComfortNoiseLevel.medium);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 2, "hasRun": true});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.off);
    var noiseLevelOff =
        await dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel();
    expect(noiseLevelOff, ComfortNoiseLevel.off);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertGetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 3, "hasRun": true});
  });

  testWidgets('MediaDeviceService: setComfortNoiseLevel', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.defaultLevel);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 0});

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.low);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 1});

    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.medium);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 2});

    await dolbyioCommsSdkFlutterPlugin.mediaDevice
        .setComfortNoiseLevel(ComfortNoiseLevel.off);
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSetComfortNoiseLevelArgs",
        expected: {"noiseLevel": 3});
  });

  testWidgets('MediaDeviceService: switchCamera', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.mediaDevice.switchCamera();
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSwitchCameraArgs",
        expected: {"hasRun": true});
  });

  testWidgets('MediaDeviceService: switchDeviceSpeaker', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.mediaDevice.switchSpeaker();
    await expectNative(
        methodChannel: mediaDeviceServiceAssertsMethodChannel,
        assertLabel: "assertSwitchDeviceSpeakerArgs",
        expected: {"hasRun": true});
  });
}
