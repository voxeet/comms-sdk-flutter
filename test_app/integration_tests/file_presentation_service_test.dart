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

  testWidgets('FilePresentationService: convert', (tester) async {
    dolbyioCommsSdkFlutterPlugin.filePresentation
        .convert(File("file:///path/to/file"));
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertConvertArgs",
        expected: {"hasRun": true, "uri": "file:///path/to/file"});
  });

  testWidgets('FilePresentationService: setPage', (tester) async {
    dolbyioCommsSdkFlutterPlugin.filePresentation.setPage(5);
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertSetPageArgs",
        expected: {"hasRun": true, "page": 5});
  });

  testWidgets('FilePresentationService: start', (tester) async {
    dolbyioCommsSdkFlutterPlugin.filePresentation
        .start(FileConverted("fileId", 10, "fileName", "fileOwnerId", 5));
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertStartArgs",
        expected: {
          "hasRun": true,
          "id": "fileId",
          "imageCount": 10,
          "name": "fileName",
          "ownerId": "fileOwnerId",
          "size": 5
        });
  });

  testWidgets('FilePresentationService: stop', (tester) async {
    dolbyioCommsSdkFlutterPlugin.filePresentation.stop();
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertStopArgs",
        expected: {"hasRun": true, "url": 'https://dolby.io/video_url'});
  });
}
