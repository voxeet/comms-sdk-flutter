import 'package:dolbyio_comms_sdk_flutter/src/mapper/mapper.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/enums.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/events.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant.dart';
import 'package:flutter/services.dart';

import 'mock_event_method_channel.dart';

class MockNotivicationServiceMethodChannel {
  var declineMethodStatus = CallStatus.NOT_CALL;
  var inviteMethodStatus = CallStatus.NOT_CALL;

  Object? onMethodCall(MethodCall call) {
    switch(call.method) {
      case "invite": {
        inviteParticipant(call.arguments as Map<Object?, Object?>?);
        return null;
      }
      case "decline": {
        decline(call.arguments as Map<Object?, Object?>?);
        return null;
      }
    }
    return null;
  }

  void inviteParticipant(Map<Object?, Object?>? args) {
    if (args != null && args.containsKey("conference") && args.containsKey("participants")) {
      var eventType = NotificationServiceEventNames.InvitationReceived.value;
      final conference = ConferenceMapper.fromMap(args["conference"] as Map<Object?, Object?>);

      final participants = (args["participants"] as List<Object?>).map((e) {
        final pMap = e as Map<Object?, Object?>;
        return ParticipantInvitedMapper.fromMap(pMap);
      }).toList();
      inviteMethodStatus = CallStatus.OK;
      var listener = MockListeners.instance.listeners[eventType];
      if (listener != null) {
        for (var p in participants) {
          var participant = conference.participants.firstWhere(
                  (element) => element.info?.name == p.info.name);
          InvitationReceivedNotificationData eventType = InvitationReceivedNotificationData(
              conference.alias!,
              conference.id!,
              "",
              participant
          );
          listener(eventType.toJson());
        }

      }
    } else {
      inviteMethodStatus = CallStatus.ERROR_INCORRECT_ARGUMENT;
    }
  }

  void decline(Map<Object?, Object?>? args) {
    if (args != null && args.containsKey("conference")) {
      final conference = ConferenceMapper.fromMap(args["conference"] as Map<Object?, Object?>);
      declineMethodStatus = CallStatus.OK;
    } else {
      declineMethodStatus = CallStatus.ERROR_INCORRECT_ARGUMENT;
    }
  }
}

enum CallStatus {
  NOT_CALL,
  OK,
  ERROR_INCORRECT_ARGUMENT,
  UNKNOWN_ERROR;
}
