import 'dart:async';

import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../dolbyio_comms_sdk_native_events.dart';
import '../mapper/mapper.dart';
import 'models/conference.dart';
import 'models/enums.dart';
import 'models/events.dart';
import 'models/participant.dart';

/// The NotificationService allows inviting participants to a conference.
class NotificationService {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel("notification_service");

  /// @internal
  final _eventStream = DolbyioCommsSdkNativeEvents.createEventChannel("notification_service").receiveBroadcastStream();

  /// Declines an invitation to a specific [conference].
  Future<void> decline(Conference conference) {
    var args = {
      "conference": conference.toJson()
    };
    return _methodChannel.invokeMethod<void>("decline", args);
  }

  /// Notifies conference participants about a conference invitation. The [participants] parameter gathers a list of participants who should be invited to a specific conference defined in the [conference] parameter.
  Future<void> invite(Conference conference, List<ParticipantInvited> participants) {
    var args = {
      "conference": conference.toJson(),
      "participants": participants.map((e) => e.toJson()).toList()
    };
    return _methodChannel.invokeMethod<void>("invite", args);
  }
  
  /// Returns a [Stream] of the [NotificationServiceEventNames.invitationReceived] events. By subscribing to the returned stream you will be notified about new conference invitations.
  Stream<Event<NotificationServiceEventNames, InvitationReceivedNotificationData>> onInvitationReceived() {
    return _eventStream.addListener([NotificationServiceEventNames.invitationReceived.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, InvitationReceivedNotificationMapper.fromMap(data));
    });
  }
}
