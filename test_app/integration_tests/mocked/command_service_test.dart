import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';

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
}
