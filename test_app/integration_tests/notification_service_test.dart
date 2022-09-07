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

  testWidgets('NotificationService: invite', (tester) async {
    await runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setFetchConferenceReturn",
        args: {"type": 1});

    var conference = await dolbyioCommsSdkFlutterPlugin.conference
        .fetch("fetch_conferenceId_1");
    dolbyioCommsSdkFlutterPlugin.notification.invite(conference, [
      ParticipantInvited(ParticipantInfo("name", "avatarUrl", "externalId"),
          [ConferencePermission.invite].toList())
    ]);
    await expectNative(
        methodChannel: notificationServiceAssertsMethodChannel,
        assertLabel: "assertInviteArgs",
        expected: {
          "hasRun": true,
          "conference": {"id": "setCreateConferenceReturn_id_1"},
          "participantInvited": {
            "name": "name",
            "avatarUrl": "avatarUrl",
            "externalId": "externalId"
          }
        });
  });

  testWidgets('NotificationService: decline', (tester) async {
    await runNative(
        methodChannel: conferenceServiceAssertsMethodChannel,
        label: "setFetchConferenceReturn",
        args: {"type": 1});

    var conference = await dolbyioCommsSdkFlutterPlugin.conference
        .fetch("fetch_conferenceId_1");

    dolbyioCommsSdkFlutterPlugin.notification.decline(conference);
    await expectNative(
        methodChannel: notificationServiceAssertsMethodChannel,
        assertLabel: "assertDeclineArgs",
        expected: {
          "hasRun": true,
          "conference": {"id": "setCreateConferenceReturn_id_1"}
        });
  });
}
