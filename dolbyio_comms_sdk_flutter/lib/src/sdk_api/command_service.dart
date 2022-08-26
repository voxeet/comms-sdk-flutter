import 'dart:async';

import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_native_events.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/enums.dart';

import '../mapper/mapper.dart';


/// The CommandService allows the application to send and receive text messages and notifications during a conference.
class CommandService {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("command_service");

  /// @internal
  late final _nativeEventsReceiver = DolbyioCommsSdkNativeEventsReceiver<CommandServiceEventNames>.forModuleNamed("command_service");

  /// Sends a [message] to all conference participants.
  Future<void> send(String message) async {
    var args = {"message": message};
    return await _methodChannel.invokeMethod<void>("send", args);
  }

  /// Returns a [Stream] of the [CommandServiceEventNames.MessageReceived] events. By subscribing to the returned stream you will be notified about received messages.
  Stream<Event<CommandServiceEventNames, MessageReceivedData>> onMessageReceived() {
    return _nativeEventsReceiver.addListener([CommandServiceEventNames.MessageReceived]).map((event) {
      final eventMap = event as Map<Object?, Object?>;
      final eventType = CommandServiceEventNames.valueOf(eventMap["key"] as String);
      final participant = MessageReceivedMapper.fromMap(eventMap["body"] as Map<Object?, Object?>);
      return Event(eventType, participant);
    });
  }
}
