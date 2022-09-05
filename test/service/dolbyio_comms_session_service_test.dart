import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';
import '../test_helpers.dart';

void main() {
  var sessionService = DolbyioCommsSdk.instance.session;

  final MethodChannel channel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("session_service");
  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test open method", () async {
    var name = "name";
    var avatarUrl = "url";
    var externalId = "123";
    var participantInfo = ParticipantInfo(name, avatarUrl, externalId);
    when(channel.invokeMethod("open")).thenAnswer((_) => Future.value());

    await sessionService.open(participantInfo);

    verify(channel.invokeMethod("open", {"name": name, "avatarUrl": avatarUrl, "externalId": externalId})).called(1);
  });

  test("test isOpen method", () async {
    var value = false;
    when(channel.invokeMethod("isOpen")).thenAnswer((_) => Future.value(value));

    var result = await sessionService.isOpen();

    expect(result, false);
    verify(channel.invokeMethod("isOpen")).called(1);
  });

  test("test close method", () async {
    when(channel.invokeMethod("close")).thenAnswer((_) => Future.value());

    await sessionService.close();

    verify(channel.invokeMethod("close")).called(1);
  });

  test("test get participant", () async {
    final participant = Participant(
      "my_id2",
      ParticipantInfo("userToInvite", null, null),
      ParticipantStatus.connected,
      ParticipantType.user,
    );
    when(channel.invokeMethod("getParticipant")).thenAnswer((_) => Future.value(participant.toJson()));

    var result = await sessionService.getParticipant();

    expectParticipant(participant, result!);
    verify(channel.invokeMethod("getParticipant")).called(1);
  });
}
