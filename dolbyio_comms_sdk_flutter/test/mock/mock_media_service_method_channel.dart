import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/enums.dart';
import 'package:flutter/services.dart';

class MockDolbyioMediaServiceMethodChannel {
  var _comfortNoiseLevel = ComfortNoiseLevel.Default;
  var _isFrontCamera = false;

  Object? onMethodCall(MethodCall call) {
    switch(call.method) {
      case "getComfortNoiseLevel":
        return _comfortNoiseLevel.name;
      case "setComfortNoiseLevel":
        var args = call.arguments as Map<Object?, Object?>;
        if (!args.keys.contains("noiseLevel")) {
          throw ArgumentError("Invalid list of arguments: missing noiseLevel");
        }
        var newValue = ComfortNoiseLevel.valueOf(args["noiseLevel"] as String);
        _comfortNoiseLevel = newValue;
        return null;
      case "isFrontCamera":
        return _isFrontCamera;
      case "switchCamera":
        _isFrontCamera = !_isFrontCamera;
        return null;
      case "switchSpeaker":
        return null;
    }
    return null;
  }
}
