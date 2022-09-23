import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/enums.dart';
import 'package:flutter/services.dart';

import 'mock_event_method_channel.dart';

class MockCommandServiceMethodChannel {
  Object? onMethodCall(MethodCall call) {
    switch (call.method) {
      case "send":
        var eventType = CommandServiceEventNames.messageReceived.value;
        var args = call.arguments as Map<Object?, Object?>?;
        var message = "";
        if (args != null && args.containsKey("message")) {
          message = args["message"] as String;
        }
        var listener = MockListeners.instance.listeners[eventType];
        if (listener != null) {
          listener(message);
          return null;
        }
    }
    return null;
  }
}
