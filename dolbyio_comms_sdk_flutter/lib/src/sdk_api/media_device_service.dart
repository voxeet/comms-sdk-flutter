import 'dart:developer' as developer;
import "dart:io" show Platform;

import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';

import 'models/enums.dart';

/// The MediaDeviceService allows an application to manage media devices that are used during a conference.
class MediaDeviceService {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
      "media_device_service");

  /// Retrieves the comfort noise level setting for output devices in Dolby Voice conferences.
  Future<ComfortNoiseLevel> getComfortNoiseLevel() async {
    return Future.value(ComfortNoiseLevel.valueOf(
        await _methodChannel.invokeMethod<String?>("getComfortNoiseLevel")));
  }

  /// Checks whether an application uses the front-facing (true) or back-facing camera (false).
  Future<bool> isFrontCamera() async {
    return Future.value(
        await _methodChannel.invokeMethod<bool>("isFrontCamera"));
  }

  /// Sets the [comfort noise level] for output devices in Dolby Voice conferences.
  Future<void> setComfortNoiseLevel(ComfortNoiseLevel noiseLevel) async {
    return await _methodChannel.invokeMethod<void>(
        "setComfortNoiseLevel", {"noiseLevel": noiseLevel.value});
  }

  /// Switches the current camera to a different camera that is available.
  Future<void> switchCamera() async {
    return await _methodChannel.invokeMethod<void>("switchCamera");
  }

  /// Switches the current speaker to a different speaker that is available.
  Future<void> switchSpeaker() async {
    if (Platform.isAndroid) {
      developer.log('Switching speaker is not available on Android devices');
      return await Future.error(
          'Switching speaker is not available on Android devices');
    } else {
      return await _methodChannel.invokeMethod<void>("switchSpeaker");
    }
  }
}
