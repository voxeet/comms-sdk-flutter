import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dolbyio_comms_sdk_flutter_platform_interface.dart';

/// An implementation of [DolbyioCommsSdkFlutterPlatform] that uses method channels.
class MethodChannelDolbyioCommsSdkFlutter
    extends DolbyioCommsSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dolbyio_comms_sdk_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // Api not implemented yet

  @override
  Future<void> send(String message) {
    // TODO: implement send
    throw UnimplementedError();
  }
}
