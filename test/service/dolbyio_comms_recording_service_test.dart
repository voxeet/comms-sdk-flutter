import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/recording.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';

void main() {
  var recordingService = DolbyioCommsSdk.instance.recording;

  final MethodChannel channel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("recording_service");
  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test getCurrentRecording method and check if result is received", () async {
    var status = RecordingStatus.notRecording;
    var participantId = "1234";
    var startTimestamp = 1658483423;
    var expected = {"recordingStatus": status.encode(), "participantId": participantId, "startTimestamp": startTimestamp};
    when(channel.invokeMethod("currentRecording")).thenAnswer((_) => Future.value(expected));

    var result = await recordingService.currentRecording();

    expect(result!.startTimestamp, startTimestamp);
    expect(result.participantId, participantId);
    expect(result.recordingStatus, status);
  });

  test("test if start method was called", () async {
    when(channel.invokeMethod("start")).thenAnswer((_) => Future.value());

    await recordingService.start();

    verify(channel.invokeMethod("start")).called(1);
  });

  test("test if stop method was called", () async {
    when(channel.invokeMethod("stop")).thenAnswer((_) => Future.value());

    await recordingService.stop();

    verify(channel.invokeMethod("stop")).called(1);
  });
}
