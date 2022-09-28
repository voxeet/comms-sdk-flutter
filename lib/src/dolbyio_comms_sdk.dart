// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:developer' as developer;
import 'dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'sdk_api/command_service.dart';
import 'sdk_api/conference_service.dart';
import 'sdk_api/file_presentation_service.dart';
import 'sdk_api/media_device_service.dart';
import 'sdk_api/notification_service.dart';
import 'sdk_api/recording_service.dart';
import 'sdk_api/session_service.dart';
import 'sdk_api/video_presentation_service.dart';

/// DolbyioCommsSdk is the main class that allows an application to interact with Dolby.io services.
class DolbyioCommsSdk {
  static final DolbyioCommsSdk instance = DolbyioCommsSdk._internal();

  final _methodChannel =
      DolbyioCommsSdkFlutterPlatform.createMethodChannel("sdk");

  /// Retrieves the CommandService instance that allows sending messages to conferences.
  final CommandService command;

  /// Retrieves the ConferenceService instance that allows interacting with conferences.
  final ConferenceService conference;

  /// Retrieves the FilePresentationService instance that allows presenting files during conferences.
  final FilePresentationService filePresentation;

  /// Retrieves the MediaDeviceService instance that allows managing devices through the system.
  final MediaDeviceService mediaDevice;

  /// Retrieves the NotificationService instance that allows inviting participants to conferences.
  final NotificationService notification;

  /// Retrieves the RecordingService instance that allows recording conferences.
  final RecordingService recording;

  /// Retrieves the SessionService instance that allows the SDK to connect with the Dolby.io backend.
  final SessionService session;

  /// Retrieves the VideoPresentationService instance that allows presenting video files during conferences.
  final VideoPresentationService videoPresentation;

  DolbyioCommsSdk._allFields(
      this.command,
      this.conference,
      this.filePresentation,
      this.mediaDevice,
      this.notification,
      this.recording,
      this.session,
      this.videoPresentation);

  factory DolbyioCommsSdk._internal() {
    final sessionService = SessionService();
    return DolbyioCommsSdk._allFields(
        CommandService(),
        ConferenceService(sessionService),
        FilePresentationService(),
        MediaDeviceService(),
        NotificationService(),
        RecordingService(),
        sessionService,
        VideoPresentationService());
  }

  /// Initializes the SDK using the [customerKey] and [customerSecret]. For security reasons, we recommend using the [initializeToken] method in production. Use initialize method only for prototyping new applications.
  Future<void> initialize(String customerKey, String customerSecret) async {
    developer.log(
        'Initialize method is deprecated. For security reasons Dolby recommends the initializeToken method in production. Use initialize method for prototyping of the app only.',
        name: "CommsApi");

    final result = await _methodChannel.invokeMethod<void>('initialize',
        {"customerKey": customerKey, "customerSecret": customerSecret});
    return result;
  }

  /// Initializes the SDK with an access token that is provided by the customer backend communicating with Dolby.io servers. The token allows securing the customer key and secret.
  /// The following diagram presents the authentication flow:
  /// ```
  /// Client          Customer Server       Dolby Server
  /// |                    |                    |
  /// |  Get Access Token  |  /oauth2/token (1) |
  /// |------------------->|------------------->|
  /// |    Access Token    |    Access Token    |
  /// |<-------------------|<-------------------|
  /// |  initializeToken(accessToken, callback) |
  /// |---------------------------------------->|
  /// ```
  /// The access token has a limited period of validity and needs to be refreshed for security reasons. In such case, the SDK calls the callback provided to initializeToken. The callback must return a promise containing the refreshed access token by calling the customer backend, as presented in the following diagram:
  ///
  /// ```
  /// Client          Customer Server       Dolby Server
  /// |      callback      |  /oauth2/token (2) |
  /// |------------------->|------------------->|
  /// |    Access Token    |    Access Token    |
  /// |<-------------------|<-------------------|
  /// ```
  /// Where (1) and (2) are the [REST API endpoints](https://docs.dolby.io/communications-apis/reference/get-client-access-token) that are available on Dolby.io servers.
  ///
  /// The method contains two parameters:
  /// - [accessToken]:  The access token provided by the customer's backend.
  /// - [refreshAccessToken]:  A callback that is called when the access token needs to be refreshed.
  Future<void> initializeToken(
      String accessToken, RefreshAccessTokenType refreshAccessToken) async {
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'getRefreshToken') {
        return await refreshAccessToken.call();
      }
    });
    return await _methodChannel
        .invokeMethod<void>("initializeToken", {"accessToken": accessToken});
  }
}

typedef RefreshAccessTokenType = Future<String?> Function();
typedef RefreshAccessTokenInBackgroundType = Function;
