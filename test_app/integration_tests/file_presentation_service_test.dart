import 'dart:io';

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
    String fileName;
    if (Platform.isIOS) {
      fileName = "file:///path/to/file";
    } else if (Platform.isAndroid) {
      fileName = "file:///path/to/file.file";
      var participant = ParticipantInfo("user", null, null);
      await dolbyioCommsSdkFlutterPlugin.session.open(participant);
    } else {
      throw UnsupportedError("Platform is not supported");
    }
    await dolbyioCommsSdkFlutterPlugin.filePresentation
        .convert(File(fileName));
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertConvertArgs",
        expected: {"hasRun": true, "uri": fileName});
  });

  testWidgets('FilePresentationService: setPage', (tester) async {
    if (Platform.isAndroid) {
      var participant = ParticipantInfo("user", null, null);
      await dolbyioCommsSdkFlutterPlugin.session.open(participant);
      var fileName = "file:///path/to/file.file";
      await dolbyioCommsSdkFlutterPlugin.filePresentation
          .convert(File(fileName));
    }
    await dolbyioCommsSdkFlutterPlugin.filePresentation.setPage(5);
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertSetPageArgs",
        expected: {"hasRun": true, "page": 5});
  });

  testWidgets('FilePresentationService: start', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.filePresentation
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
    if (Platform.isAndroid) {
      var fileName = "file:///path/to/file.file";
      var participant = ParticipantInfo("user", null, null);
      await dolbyioCommsSdkFlutterPlugin.session.open(participant);
      await dolbyioCommsSdkFlutterPlugin.filePresentation
        .convert(File(fileName));
    }
    await dolbyioCommsSdkFlutterPlugin.filePresentation.stop();
    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertStopArgs",
        expected: {"hasRun": true, "url": 'https://dolby.io/video_url'});
  });

  testWidgets('FilePresentationService: getImage', (tester) async {
    await runNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        label: "setGetImageReturn",
        args: {"hasRun": true, "url": 'https://dolby.io/image_url'});

    if (Platform.isAndroid) {
      var fileName = "file:///path/to/file.file";
      var participant = ParticipantInfo("user", null, null);
      await dolbyioCommsSdkFlutterPlugin.session.open(participant);
      await dolbyioCommsSdkFlutterPlugin.filePresentation
          .convert(File(fileName));
    }
    var url = await dolbyioCommsSdkFlutterPlugin.filePresentation.getImage(5);

    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertGetImageArgs",
        expected: {"hasRun": true, "page": 5});

    expect(url, 'https://dolby.io/image_url');
  });

  testWidgets('FilePresentationService: getThumbnail', (tester) async {
    await runNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        label: "setGetThumbnailReturn",
        args: {"hasRun": true, "url": 'https://dolby.io/thumbnail_url'});

    if (Platform.isAndroid) {
      var fileName = "file:///path/to/file.file";
      var participant = ParticipantInfo("user", null, null);
      await dolbyioCommsSdkFlutterPlugin.session.open(participant);
      await dolbyioCommsSdkFlutterPlugin.filePresentation
          .convert(File(fileName));
    }
    var url =
        await dolbyioCommsSdkFlutterPlugin.filePresentation.getThumbnail(3);

    await expectNative(
        methodChannel: filePresentationServiceAssertsMethodChannel,
        assertLabel: "assertGetThumbnailArgs",
        expected: {"hasRun": true, "page": 3});

    expect(url, 'https://dolby.io/thumbnail_url');
  });
}
