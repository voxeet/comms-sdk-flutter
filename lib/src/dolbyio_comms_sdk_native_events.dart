import 'dart:async';
import 'package:flutter/services.dart';
import 'sdk_api/models/enums.dart';

class DolbyioCommsSdkNativeEvents {
  static EventChannel createEventChannel(String moduleName) {
    return EventChannel('dolbyio_${moduleName}_event_channel');
  }
}

extension NativeEventsListener on Stream {
  Stream<dynamic> addListener(List<String> events) {
    return where((event) {
      var eventData = event as Map<Object?, Object?>;
      return events.contains(eventData["key"]);
    });
  }
}

class DolbyioCommsSdkNativeEventsReceiver<T extends EnumWithStringValue> {
  // final EventChannel _eventChannel;
  final Stream<dynamic> _stream;

  DolbyioCommsSdkNativeEventsReceiver(this._stream);

  factory DolbyioCommsSdkNativeEventsReceiver.forModuleNamed(
      String moduleName) {
    final eventChannel = EventChannel('dolbyio_${moduleName}_event_channel');
    return DolbyioCommsSdkNativeEventsReceiver(
        eventChannel.receiveBroadcastStream());
  }

  Stream<dynamic> addListener(List<T> events) {
    final eventNames = events.map((e) => e.value);
    return _stream.where((event) {
      var eventData = event as Map<Object?, Object?>;
      return eventNames.contains(eventData["key"]);
    });
  }
}

/// Describes a generic event.
///
/// The generic [T] is the type of the event and is usually an enum, while [B] is the body of
/// the event which is typically a class for which some change has happened.
class Event<T, B> {
  /// The type of the event that is usually an element of an enum.
  T type;

  /// The body of the event that is usually a changed class.
  B body;

  /// Constructs an [Event] instance based on the type and the body.
  Event(this.type, this.body);
}

typedef EventListener = void Function(dynamic);
typedef UnregisterListener = void Function();
