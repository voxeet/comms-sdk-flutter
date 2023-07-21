import 'dart:async';
import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../mapper/mapper.dart';
import 'models/participant.dart';
import 'models/participant_info.dart';

/// The SessionService allows connecting the SDK with the Dolby.io backend via the [open] method. Opening a session is mandatory before interacting with any service.
///
/// {@category Services}
class SessionService {
  /// @internal
  final _methodChannel =
      DolbyioCommsSdkFlutterPlatform.createMethodChannel("session_service");

  /// Opens a new session to connect the SDK with the Dolby.io backend. The [participantInfo] parameter refers to an additional information about the local participant.
  Future<void> open(ParticipantInfo participantInfo) async {
    var params = {
      "name": participantInfo.name,
      "avatarUrl": participantInfo.avatarUrl,
      "externalId": participantInfo.externalId
    };
    await _methodChannel.invokeMethod<void>('open', params);
    return Future.value();
  }

  /// Updates the local participant's name and avatar URL. This method is supported in SDK 3.10 and later.
  Future<void> updateParticipantInfo(String name, String avatarUrl) async {
    var params = {"name": name, "avatarUrl": avatarUrl};
    await _methodChannel.invokeMethod<void>('updateParticipantInfo', params);
    return Future.value();
  }

  /// Checks whether there is an open session that connects SDK with the backend.
  Future<bool> isOpen() async {
    final result = await _methodChannel.invokeMethod<bool>('isOpen');
    return Future.value(result);
  }

  /// Provides the local participant object that belongs to the current session.
  Future<Participant?> getParticipant() async {
    final result = await _methodChannel
        .invokeMethod<Map<Object?, Object?>>('getParticipant');
    return result != null ? ParticipantMapper.fromMap(result) : null;
  }

  /// Closes the current session.
  Future<void> close() async {
    await _methodChannel.invokeMethod('close');
    return Future.value();
  }
}
