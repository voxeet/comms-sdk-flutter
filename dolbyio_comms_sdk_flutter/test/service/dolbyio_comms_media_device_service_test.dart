import 'dart:developer' as developer;

import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_event_method_channel.dart';
import '../mock/mock_media_service_method_channel.dart';

void main() {
  var mediaDeviceService = DolbyioCommsSdk.instance.mediaDevice;
  final MethodChannel channel =
      DolbyioCommsSdkFlutterPlatform.createMethodChannel(
          "media_device_service");

  final mockMethodChannel = MockDolbyioMediaServiceMethodChannel();
  final mockEventEmitter = MockEventMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.onMethodCall(methodCall);
    });
    mockEventEmitter.prepare();
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
    mockEventEmitter.release();
  });

  developer.log("start test");

  test("test getComfortNoiseLevel method and check if result is received",
      () async {
    var comfortNoiseLevel = await mediaDeviceService.getComfortNoiseLevel();
    expect(ComfortNoiseLevel.Default, comfortNoiseLevel);
  });

  test("test setComfortNoiseLevel method and check if result is received",
      () async {
    // set low level
    mediaDeviceService.setComfortNoiseLevel(ComfortNoiseLevel.Low);
    expect(
        ComfortNoiseLevel.Low, await mediaDeviceService.getComfortNoiseLevel());

    // set off level
    mediaDeviceService.setComfortNoiseLevel(ComfortNoiseLevel.Off);
    expect(
        ComfortNoiseLevel.Off, await mediaDeviceService.getComfortNoiseLevel());

    // set medium level
    mediaDeviceService.setComfortNoiseLevel(ComfortNoiseLevel.Medium);
    expect(ComfortNoiseLevel.Medium,
        await mediaDeviceService.getComfortNoiseLevel());
  });

  test("test default value of isFrontCamera method", () async {
    expect(false, await mediaDeviceService.isFrontCamera());
  });

  test("test switchCamera method", () async {
    // switch camera, by default isFrontCamera = false
    mediaDeviceService.switchCamera();

    // check if camera was switched to front
    expect(true, await mediaDeviceService.isFrontCamera());
  });
}
