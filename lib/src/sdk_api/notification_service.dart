import 'dart:async';

import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../dolbyio_comms_sdk_native_events.dart';
import '../mapper/mapper.dart';
import 'models/conference.dart';
import 'models/enums.dart';
import 'models/events.dart';
import 'models/participant.dart';
import 'models/subscription.dart';

/// The NotificationService allows inviting participants to a conference.
///
/// {@category Services}
class NotificationService {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
      "notification_service");

  /// @internal
  final _eventStream =
      DolbyioCommsSdkNativeEvents.createEventChannel("notification_service")
          .receiveBroadcastStream();

  /// Declines an invitation to a specific [conference].
  Future<void> decline(Conference conference) {
    var args = {"conference": conference.toJson()};
    return _methodChannel.invokeMethod<void>("decline", args);
  }

  /// Notifies conference participants about a conference invitation. The [participants] parameter gathers a list of participants who should be invited to a specific conference defined in the [conference] parameter.
  Future<void> invite(
      Conference conference, List<ParticipantInvited> participants) {
    var args = {
      "conference": conference.toJson(),
      "participants": participants.map((e) => e.toJson()).toList()
    };
    return _methodChannel.invokeMethod<void>("invite", args);
  }

  /// Subscribes to the specified notifications.
  /// [events] - An array of the subscribed subscription types.
  Future<void> subscribe(List<Subscription> events) {
    var args = {"subscriptions": events.map((e) => e.toJson()).toList()};
    return _methodChannel.invokeMethod<void>("subscribe", args);
  }

  /// Unsubscribes from the specified notifications.
  /// [events] An array of the subscribed subscription types.
  Future<void> unsubscribe(List<Subscription> events) {
    var args = {"subscriptions": events.map((e) => e.toJson()).toList()};
    return _methodChannel.invokeMethod<void>("unsubscribe", args);
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.invitationReceived] events. By subscribing to the returned stream you will be notified about new conference invitations.
  Stream<
      Event<NotificationServiceEventNames,
          InvitationReceivedNotificationData>> onInvitationReceived() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.invitationReceived.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, InvitationReceivedNotificationMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.conferenceStatus] events. By subscribing to the returned stream you will be notified about conference status.
  Stream<Event<NotificationServiceEventNames, ConferenceStatusNotificationData>>
      onConferenceStatus() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.conferenceStatus.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, ConferenceStatusNotificationMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.conferenceCreated] events. By subscribing to the returned stream you will be notified about new conference invitations.
  Stream<
      Event<NotificationServiceEventNames,
          ConferenceCreatedNotificationData>> onConferenceCreated() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.conferenceCreated.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, ConferenceCreatedNotificationMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.conferenceEnded] events. By subscribing to the returned stream you will be notified about new conference invitations.
  Stream<Event<NotificationServiceEventNames, ConferenceEndedNotificationData>>
      onConferenceEnded() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.conferenceEnded.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, ConferenceEndedNotificationMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.activeParticipants] events. By subscribing to the returned stream you will be notified about changes of active participants.
  Stream<
      Event<NotificationServiceEventNames,
          ActiveParticipantsNotificationData>> onActiveParticipants() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.activeParticipants.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, ActiveParticipantsNotificationMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.participantJoined] events. By subscribing to the returned stream you will be notified when participants join the conference.
  Stream<Event<NotificationServiceEventNames, ParticipantJoinedNotificationData>>
  onParticipantJoined() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.participantJoined.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, ParticipantJoinedNotificationMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [NotificationServiceEventNames.participantLeft] events. By subscribing to the returned stream you will be notified when participants leave the conference.
  Stream<Event<NotificationServiceEventNames, ParticipantLeftNotificationData>>
  onParticipantLeft() {
    return _eventStream.addListener(
        [NotificationServiceEventNames.participantLeft.value]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key = NotificationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, ParticipantLeftNotificationMapper.fromMap(data));
    });
  }
}
