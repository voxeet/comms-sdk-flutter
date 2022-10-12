## 3.6.0-beta.4

### Bug fixes

- Fixed an issue where the start and stop methods of the [VideoPresentationService](./lib/src/sdk_api/video_presentation_service.dart) did not work properly.
- Improved error reporting on iOS.
- Fixed a crash that occurred when accessing the current recording.
- Fixed an issue with [converting](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/FilePresentationService/convert.html) files on iOS devices.
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