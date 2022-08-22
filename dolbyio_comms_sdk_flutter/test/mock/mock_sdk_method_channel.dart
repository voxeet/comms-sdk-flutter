import 'package:flutter/services.dart';

class MockSdkMethodChannel {
  Object? onMethodCall(MethodCall call) {
    switch (call.method) {
      case "initialize":
        return null;
      case "initializeToken":
        return null;
    }
    return null;
  }
}
