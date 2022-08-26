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

  testWidgets('CommandService: send', (tester) async {
    
    await dolbyioCommsSdkFlutterPlugin.command.send("test");

    await expectNative(
      methodChannel: commandServiceAssertsMethodChannel, 
      assertLabel: "assertSendArgs", 
      expected: {"message": "test"});
  });

  testWidgets('CommandService: received', (tester) async {

    await runNative(
      methodChannel: commandServiceAssertsMethodChannel, 
      label: "emitOnMessageReceived",
      args: { });

    List<Event<CommandServiceEventNames, MessageReceivedData>> receivedEvents = [];
    await for (final event in dolbyioCommsSdkFlutterPlugin.command.onMessageReceived()) {
      receivedEvents.add(event);
      if (receivedEvents.length > 2) {
        break;
      }
    }
    expect(receivedEvents[0].body.message, "test");
    expect(receivedEvents[1].body.participant, "participant_id_5_1");
  });
}
