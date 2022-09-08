import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/secondary_button.dart';
import '/screens/join_screen.dart';
import '/widgets/dialogs.dart';
import 'dart:convert';

class ConferenceServiceTestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  ConferenceServiceTestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(text: 'Leave', onPressed: () => leave(context)),
        SecondaryButton(text: 'Get participant', onPressed: () => getParticipant(context)),
        SecondaryButton(text: 'Get participants', onPressed: () => getParticipants(context)),
        SecondaryButton(text: 'Fetch conference', onPressed: () => fetchConference(context)),
        SecondaryButton(text: 'Current conference', onPressed: () => current(context)),
        SecondaryButton(text: 'GetAudioLevel', onPressed: () => getAudioLevel(context)),
        SecondaryButton(text: 'IsMuted', onPressed: () => isMuted(context)),
        SecondaryButton(text: 'Mute', onPressed: () => setMute(context, true)),
        SecondaryButton(text: 'Unmute', onPressed: () => setMute(context, false)),
        SecondaryButton(text: 'Mute output', onPressed: () => setMuteOutput(context, true)),
        SecondaryButton(text: 'Unmute output', onPressed: () => setMuteOutput(context, false)),
        SecondaryButton(text: 'Start audio', onPressed: () => startAudio(context)),
        SecondaryButton(text: 'Stop audio', onPressed: () => stopAudio(context)),
        SecondaryButton(text: 'Start video', onPressed: () => startVideo(context)),
        SecondaryButton(text: 'Stop video', onPressed: () => stopVideo(context)),
        SecondaryButton(text: 'Start screen share', onPressed: () => startScreenShare(context)),
        SecondaryButton(text: 'Stop screen share', onPressed: () => stopScreenShare(context)),
        SecondaryButton(text: 'Set my spatial position', onPressed: () => setMySpatialPosition(context)),
        SecondaryButton(text: 'Set spatial position', onPressed: () => setSpatialPosition(context)),
        SecondaryButton(text: 'Set spatial direction', onPressed: () => setSpatialDirection(context)),
        SecondaryButton(text: 'Set spatial environment', onPressed: () => setSpatialEnvironment(context)),
        SecondaryButton(text: 'Get local stats', onPressed: () => getLocalStats(context)),
        SecondaryButton(text: 'Set max video forwarding', onPressed: () => setMaxVideoForwarding(context)),
        SecondaryButton(text: 'Set video forwarding', onPressed: () => setVideoForwarding(context)),
        SecondaryButton(text: 'Set audio processing', onPressed: () => setAudioProcessing(context)),
        SecondaryButton(text: 'Is speaking', onPressed: () => isSpeaking(context)),
        SecondaryButton(text: 'Get max video forwarding', onPressed: () => getMaxVideoForwarding(context)),
      ],
    );
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void getParticipant(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipant(conference.participants.first.id))
        .then((participant) => showDialog(context, 'Success', participant.toJson().toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getParticipants(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(conference))
        .then((participants) => showDialog(context, 'Success', jsonEncode(participants)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void fetchConference(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.fetch(conference.id))
        .then((conference) => showDialog(context, 'Success', conference.toJson().toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void current(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => showDialog(context, 'Success', conference.toJson().toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getAudioLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getAudioLevel(conference.participants.first))
        .then((audioLevel) => showDialog(context, 'Success', audioLevel.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void leave(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.leave())
        .then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JoinConference(username: ''))))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void isMuted(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .isMuted()
        .then((isMuted) => showDialog(context, 'Success', isMuted.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setMute(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.mute(conference.participants.first, mute))
        .then((isMuted) => showDialog(context, 'Success', isMuted.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setMuteOutput(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .muteOutput(mute)
        .then((isMuted) => showDialog(context, 'Success', isMuted.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void startAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.startAudio(conference.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString())));
  }

  void stopAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.stopAudio(conference.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString())));
  }

  void startVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.startVideo(conference.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString())));
  }

  void stopVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.stopVideo(conference.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString())));
  }

  void startScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.startScreenShare())
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString()));
  }

  void stopScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare())
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString()));
  }

  void setMySpatialPosition(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialPosition(position: SpatialPosition(1.0, 1.0, 1.0))
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setSpatialPosition(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(conference))
        .then((participants) => _dolbyioCommsSdkFlutterPlugin.conference.setSpatialPosition(
          participant: participants.first,
          position: SpatialPosition(1.0, 1.0, 1.0),
        ))
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setSpatialEnvironment(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialEnvironment(
          SpatialScale(1.0, 1.0, 1.0),
          SpatialPosition(0.0, 0.0, 1.0),
          SpatialPosition(0.0, 1.0, 0.0),
          SpatialPosition(1.0, 0.0, 0.0)
        )
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setSpatialDirection(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialDirection(SpatialDirection(1.0, 1.0, 1.0))
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getLocalStats(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalStats()
        .then((rtcStatsTypes) => showDialog(context, 'Success', jsonEncode(rtcStatsTypes)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setMaxVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(conference))
        .then((participants) => _dolbyioCommsSdkFlutterPlugin.conference.setMaxVideoForwarding(4, participants))
        .then((value) => showDialog(context, 'Success', jsonEncode(value)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(conference))
        .then((participants) => _dolbyioCommsSdkFlutterPlugin.conference.setVideoForwarding(VideoForwardingStrategy.lastSpeaker, 4, participants))
        .then((value) => showDialog(context, 'Success', jsonEncode(value)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setAudioProcessing(BuildContext context) {
    var senderOptions = AudioProcessingSenderOptions()..audioProcessing = true;
    var audioProcessingOptions = AudioProcessingOptions()..send = senderOptions;
    _dolbyioCommsSdkFlutterPlugin.conference
        .setAudioProcessing(audioProcessingOptions)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void isSpeaking(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(conference))
        .then((participants) => _dolbyioCommsSdkFlutterPlugin.conference.isSpeaking(participants.first))
        .then((isSpeaking) => showDialog(context, 'Success', isSpeaking.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getMaxVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
    .getMaxVideoForwarding()
    .then((maxVideoForwarding) => showDialog(context, 'Success', maxVideoForwarding.toString()))
    .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }
}
