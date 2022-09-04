import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/conference.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';

final userToInvite =
    Participant("my_id2", ParticipantInfo("userToInvite", null, null), ParticipantStatus.connected, ParticipantType.user);

var participants = [
  Participant("my_id", ParticipantInfo("test", null, null), ParticipantStatus.connected, ParticipantType.user),
  userToInvite
];

var participantsInvitation = [
  ParticipantInvited(userToInvite.info!, [ConferencePermission.sendAudio])
];

var conference = Conference("test_conf", "test_id", true, participants, ConferenceStatus.joined);

void main() {
  var notificationService = DolbyioCommsSdk.instance.notification;

  final MethodChannel channel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("notification_service");
  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test invite method", () async {
    when(channel.invokeMethod("invite")).thenAnswer((_) => Future.value());

    notificationService.invite(conference, participantsInvitation);

    verify(channel.invokeMethod(
      "invite",
      {"conference": conference.toJson(), "participants": participantsInvitation.map((e) => e.toJson()).toList()},
    )).called(1);
  });

  test("test decline method", () async {
    when(channel.invokeMethod("decline")).thenAnswer((_) => Future.value());

    notificationService.decline(conference);

    verify(channel.invokeMethod(
      "decline",
      {"conference": conference.toJson()},
    )).called(1);
  });
}
