import 'dart:async';
import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../dolbyio_comms_sdk_native_events.dart';
import '../mapper/mapper.dart';
import 'models/enums.dart';
import 'models/events.dart';

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

  /// Returns a [Stream] of the [CommandServiceEventNames.messageReceived] events. By subscribing to the returned stream you will be notified about received messages.
  Stream<Event<CommandServiceEventNames, MessageReceivedData>> onMessageReceived() {
    return _nativeEventsReceiver.addListener([CommandServiceEventNames.messageReceived]).map((event) {
      final eventMap = event as Map<Object?, Object?>;
      final eventType = CommandServiceEventNames.valueOf(eventMap["key"] as String);
      final participant = MessageReceivedMapper.fromMap(eventMap["body"] as Map<Object?, Object?>);
      return Event(eventType, participant);
    });
  }
}
