import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEventMethodChannel {
  final EventChannel eventChannel =
      const EventChannel("dolbyio_event_main_channel");

  StandardMethodCodec codec = const StandardMethodCodec();

  Future<ByteData?> handle(ByteData? message) async {
    if (message != null) {
      MethodCall call = codec.decodeMethodCall(message);
      switch (call.method) {
        case "listen":
          var arguments = call.arguments as Map<Object?, Object?>?;
          if (arguments != null && arguments.containsKey("events")) {
            var eventsType = arguments["events"] as List<dynamic>;
            for (var element in eventsType) {
              MockListeners.instance.listeners[element as String] = (msg) {
                var codec = const StandardMethodCodec();

                eventChannel.binaryMessenger.handlePlatformMessage(
                    eventChannel.name,
                    codec.encodeSuccessEnvelope(msg),
                    (data) {});
              };
            }
          }
          return Future(() => codec.encodeSuccessEnvelope(""));
      }
    }

    return Future.error("Not implementend event call");
  }

  void prepare() {
    eventChannel.binaryMessenger
        .setMockMessageHandler(eventChannel.name, handle);
  }

  void release() {
    eventChannel.binaryMessenger.setMockMessageHandler(eventChannel.name, null);
  }
}

class MockListeners {
  Map<String, void Function(dynamic msg)> listeners =
      HashMap<String, void Function(dynamic msg)>();

  static final instance = MockListeners();
}
