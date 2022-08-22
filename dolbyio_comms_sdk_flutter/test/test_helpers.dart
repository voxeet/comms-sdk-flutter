import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant_info.dart';
import 'package:flutter_test/flutter_test.dart';

void expectParticipant(Participant actual, Participant matcher) {
  expect(actual.id, matcher.id);
  expectParticipantInfo(actual.info, matcher.info);
  expect(actual.status, matcher.status);
  expect(actual.type, matcher.type);
}

void expectParticipantInfo(ParticipantInfo? actual, ParticipantInfo? matcher) {
  expect(actual?.name, matcher?.name);
  expect(actual?.avatarUrl, matcher?.avatarUrl);
  expect(actual?.externalId, matcher?.externalId);
}
