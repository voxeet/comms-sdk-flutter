import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';

extension ConferenceServiceExt on ConferenceService {
  Future<Participant> getLocalParticipant() async {
    var conf = await DolbyioCommsSdk.instance.conference.current();
    var sessionParticipant = await DolbyioCommsSdk.instance.session.getParticipant();
    return conf.participants.firstWhere((element) => element.id == sessionParticipant!.id);
  }
}