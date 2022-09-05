import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';
import '../test_helpers.dart';

final participant = Participant(
  "my_id2",
  ParticipantInfo("userToInvite", null, null),
  ParticipantStatus.connected,
  ParticipantType.user,
);

void main() {
  var filePresentationService = DolbyioCommsSdk.instance.filePresentation;

  final MethodChannel channel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("file_presentation_service");
  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test convert file method", () async {
    var file = File("some uri to file");
    var name = "name";
    var ownerId = "9";
    var size = 124040;
    var presentationId = "1234";
    var imageCount = 12;
    when(channel.invokeMethod("convert", file.toJson())).thenAnswer(
      (_) => Future.value({"id": presentationId, "imageCount": imageCount, "ownerId": ownerId, "size": size, "name": name}),
    );

    var result = await filePresentationService.convert(file);

    expect(result.id, presentationId);
    expect(result.imageCount, imageCount);
    expect(result.name, name);
    expect(result.ownerId, ownerId);
    expect(result.size, size);
    verify(channel.invokeMethod("convert", {"uri": "some uri to file"})).called(1);
  });

  test("test get current file presentation method", () async {
    var position = 11;
    var presentationId = "1234";
    var imageCount = 12;
    when(channel.invokeMethod("getCurrent")).thenAnswer(
      (_) => Future.value({"id": presentationId, "imageCount": imageCount, "position": position, "owner": participant.toJson()}),
    );

    var result = await filePresentationService.getCurrent();

    expect(result.id, presentationId);
    expect(result.imageCount, imageCount);
    expect(result.position, position);
    expectParticipant(result.owner, participant);
    verify(channel.invokeMethod("getCurrent")).called(1);
  });

  test("test getImage method", () async {
    var pageNumber = 1;
    var exampleUrl = "some image url";
    when(channel.invokeMethod("getImage", {"page": pageNumber})).thenAnswer((_) => Future.value(exampleUrl));

    var result = await filePresentationService.getImage(pageNumber);

    expect(result, exampleUrl);
    verify(channel.invokeMethod("getImage", {"page": pageNumber})).called(1);
  });

  test("test getThumbnail method", () async {
    var pageNumber = 1;
    var exampleUrl = "some image url";
    when(channel.invokeMethod("getThumbnail", {"page": pageNumber})).thenAnswer((_) => Future.value(exampleUrl));

    var result = await filePresentationService.getThumbnail(pageNumber);

    expect(result, exampleUrl);
    verify(channel.invokeMethod("getThumbnail", {"page": pageNumber})).called(1);
  });

  test("test setPage method", () async {
    var pageNumber = 1;
    when(channel.invokeMethod("setPage", {"page": pageNumber})).thenAnswer((_) => Future.value());

    await filePresentationService.setPage(pageNumber);

    verify(channel.invokeMethod("setPage", {"page": pageNumber})).called(1);
  });

  test("test start file presentation method", () async {
    var fileConverted = FileConverted("123", 12, "test name", "1", 0.0);
    when(channel.invokeMethod("start")).thenAnswer((_) => Future.value());

    await filePresentationService.start(fileConverted);

    verify(channel.invokeMethod("start", fileConverted.toJson())).called(1);
  });

  test("test stop file presentation method", () async {
    when(channel.invokeMethod("stop")).thenAnswer((_) => Future.value());

    await filePresentationService.stop();

    verify(channel.invokeMethod("stop")).called(1);
  });
}
