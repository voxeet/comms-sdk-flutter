import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });

  testWidgets('VoxeetSDK: initilise', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.initialize(
        "test_consumer_key", "test_consumer_secret");
    await expectNative(
        methodChannel: voxeetSDKAsertsMethodChannel,
        assertLabel: "assertInitializeConsumerKeyAndSecret",
        expected: {
          "consumerKey": "test_consumer_key",
          "consumerSecret": "test_consumer_secret"
        });

    await resetSDK();

    await dolbyioCommsSdkFlutterPlugin.initialize(
        "test_consumer_key1", "test_consumer_secret2");
    await expectNative(
        methodChannel: voxeetSDKAsertsMethodChannel,
        assertLabel: "assertInitializeConsumerKeyAndSecret",
        expected: {
          "consumerKey": "test_consumer_key1",
          "consumerSecret": "test_consumer_secret2"
        });
  });

  testWidgets('VoxeetSDK: initializeToken', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.initializeToken("token", () => throw '');
    await expectNative(
        methodChannel: voxeetSDKAsertsMethodChannel,
        assertLabel: "assertInitializeToken",
        expected: {"accessToken": "token"});
  });
}
