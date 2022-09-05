import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';
import '../mock/mock_models.dart';

void main() {
  var videoPresentationService = DolbyioCommsSdk.instance.videoPresentation;

  final MethodChannel channel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("video_presentation_service");
  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test start video presentation method", () async {
    var exampleUrl = "some url";
    when(channel.invokeMethod("start")).thenAnswer((_) => Future.value());

    await videoPresentationService.start(exampleUrl);

    verify(channel.invokeMethod("start", {"url": exampleUrl})).called(1);
  });

  test("test stop video presentation method", () async {
    when(channel.invokeMethod("stop")).thenAnswer((_) => Future.value());

    await videoPresentationService.stop();

    verify(channel.invokeMethod("stop")).called(1);
  });

  test("test play video presentation method", () async {
    when(channel.invokeMethod("play")).thenAnswer((_) => Future.value());

    await videoPresentationService.play();

    verify(channel.invokeMethod("play")).called(1);
  });

  test("test pause video presentation method", () async {
    var exampleTimestamp = 1658835700;
    when(channel.invokeMethod("pause")).thenAnswer((_) => Future.value());

    await videoPresentationService.pause(exampleTimestamp);

    verify(channel.invokeMethod("pause", {"timestamp": exampleTimestamp})).called(1);
  });

  test("test seek video presentation method", () async {
    var exampleTimestamp = 500;
    when(channel.invokeMethod("seek")).thenAnswer((_) => Future.value());

    await videoPresentationService.seek(exampleTimestamp);

    verify(channel.invokeMethod("seek", {"timestamp": exampleTimestamp})).called(1);
  });

  test("test video presentation state method", () async {
    var expectedState = VideoPresentationState.paused;
    when(channel.invokeMethod("state")).thenAnswer((_) => Future.value("paused"));

    var result = await videoPresentationService.state();

    expect(result, expectedState);
    verify(channel.invokeMethod("state")).called(1);
  });

  test("test state video presentation method", () async {
    var expectedParticipant = MockModels.participant();
    var expectedValue = VideoPresentation(expectedParticipant, 500, "url");
    when(channel.invokeMethod("currentVideo")).thenAnswer(
      (_) => Future.value({
        "owner": {"id": expectedParticipant.id},
        "timestamp": expectedValue.timestamp,
        "url": expectedValue.url
      }),
    );

    var result = await videoPresentationService.currentVideo();

    expect(result!.url, expectedValue.url);
    expect(result.timestamp, expectedValue.timestamp);
    expect(result.owner.id, expectedValue.owner.id);
    verify(channel.invokeMethod("currentVideo")).called(1);
  });
}
