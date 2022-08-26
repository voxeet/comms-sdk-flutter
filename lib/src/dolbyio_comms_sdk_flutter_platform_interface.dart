import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dolbyio_comms_sdk_flutter_method_channel.dart';

abstract class DolbyioCommsSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a DolbyioCommsSdkFlutterPlatform.
  DolbyioCommsSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static DolbyioCommsSdkFlutterPlatform _instance =
      MethodChannelDolbyioCommsSdkFlutter();

  static MethodChannel createMethodChannel(String moduleName) {
    return MethodChannel('dolbyio_${moduleName}_channel');
  }

  /// The default instance of [DolbyioCommsSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelDolbyioCommsSdkFlutter].
  static DolbyioCommsSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DolbyioCommsSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(DolbyioCommsSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
