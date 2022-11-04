## 3.6.1

### Features

- Introduced SpatialAudioStyle that defines how the spatial location is communicated between SDK and the Dolby.io server.
- Introduced obfuscation rules to simplify the obfuscation of Android applications.

### Changes

- Deprecated the [setMaxVideoForwarding](./lib/src/sdk_api/conference_service.dart) method. To set Video Forwarding in this and later releases, use the [setVideoForwarding](./lib/src/sdk_api/conference_service.dart) method. 

### Bug fixes

- Fixed an issue where the conferenceAccessToken did not refresh correctly on Android.
- Fixed an issue where the updatePermissions method did not work correctly on Android.

## 3.6.0

### Features

Introduced the Flutter SDK that allows creating high-quality applications for video conferencing. With Flutter, you can write a single codebase in [Dart](https://dart.dev/) that you can natively compile and use for building, testing, and deploying applications across multiple platforms. Currently, the Flutter SDK supports creating applications for iOS and Android devices. The SDK offers the same [functionalities](https://docs.dolby.io/communications-apis/docs/overview-introduction) that are available in Android and iOS SDK.

## 3.6.0-beta.5

### Bug fixes

Fixed an issue that occurred on Android devices where participants who left a conference, closed a session, and rejoined the conference could not see themselves on the participants list.

## 3.6.0-beta.4

### Bug fixes

- Fixed an issue where the start and stop methods of the [VideoPresentationService](./lib/src/sdk_api/video_presentation_service.dart) did not work properly.
- Improved error reporting on iOS.
- Fixed a crash that occurred when accessing the current recording.
- Fixed an issue with converting files on iOS devices.
- Fixed an issue with receiving events from the [FilePresentationService](./lib/src/sdk_api/file_presentation_service.dart) and [VideoPresentationService](./lib/src/sdk_api/video_presentation_service.dart) on iOS devices.
- Added an option to switch speakers on Android devices.
- Unified error messages on iOS and Android devices.

## 3.6.0-beta.3

### Bug fixes:

Fixed an issue where the SDK required inheriting the Android activity provided by the plugin in order to share a screen.

## 3.6.0-beta.2

- Added support for [FilePresentationService](./lib/src/sdk_api/file_presentation_service.dart) on iOS devices

- Improved video stream management

## 3.6.0-beta.1

Introduced the Flutter SDK that supports creating high-quality video conferencing applications for iOS and Android devices.

## 0.0.1

Initial release