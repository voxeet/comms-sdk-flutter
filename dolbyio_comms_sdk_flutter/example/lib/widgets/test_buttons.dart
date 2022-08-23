import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/file_presentation_test_buttons.dart';
import '/widgets/secondary_button.dart';
import '/widgets/video_presentation_test_buttons.dart';
import '/example_app/join_screen.dart';
import 'dialogs.dart';
import 'dart:convert';

class TestButtons extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  TestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 10),
            const Text("Conference service"),
            const SizedBox(height: 10),
            SecondaryButton(text: 'Leave', onPressed: () => leave(context)),
            SecondaryButton(text: 'Get participant', onPressed: () => getParticipant(context)),
            SecondaryButton(text: 'Get participants', onPressed: () => getParticipants(context)),
            SecondaryButton(text: 'Fetch conference', onPressed: () => fetchConference(context)),
            SecondaryButton(text: 'Current conference', onPressed: () => current(context)),
            SecondaryButton(text: 'GetAudioLevel', onPressed: () => getAudioLevel(context)),
            SecondaryButton(text: 'IsMuted', onPressed: () => isMuted(context)),
            SecondaryButton(text: 'Mute', onPressed: () => setMute(context, true)),
            SecondaryButton(text: 'Unmute', onPressed: () => setMute(context, false)),
            SecondaryButton(text: 'Mute output', onPressed: () => setMute(context, true)),
            SecondaryButton(text: 'Unmute output', onPressed: () => setMute(context, false)),
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
            SecondaryButton(text: 'Update permissions', onPressed: () => updatePermissions(context)),
            const SizedBox(height: 10),
            const Text("Recording service"),
            const SizedBox(height: 10),
            SecondaryButton(text: 'Start recording', onPressed: () => startRecording(context)),
            SecondaryButton(text: 'Stop recording', onPressed: () => stopRecording(context)),
            SecondaryButton(text: 'Current recording', onPressed: () => currentRecording(context)),
            const SizedBox(height: 10),
            const Text("Media Device service"),
            const SizedBox(height: 10),
            SecondaryButton(text: 'Get comfort noise level', onPressed: () => getComfortNoiseLevel(context)),
            SecondaryButton(text: 'Set comfort noise level', onPressed: () => setComfortNoiseLevel(context)),
            SecondaryButton(text: 'Is front camera', onPressed: () => isFrontCamera(context)),
            SecondaryButton(text: 'Switch camera', onPressed: () => switchCamera(context)),
            const SizedBox(height: 10),
            const Text("Command service"),
            const SizedBox(height: 10),
            SecondaryButton(text: 'Send message', onPressed: () => send(context)),
            const SizedBox(height: 10),
            const Text("File presentation service"),
            const SizedBox(height: 10),
            FilePresentationTestButtons(),
            const SizedBox(height: 10),
            const Text("Video presentation service"),
            const SizedBox(height: 10),
            const VideoPresentationTestButtons()
          ],
        ),
      ),
    );
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  //Conference service
  void getParticipant(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipant(value.participants.first.id))
        .then((value) => showDialog(context, 'Success', value.toJson().toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getParticipants(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => showDialog(context, 'Success', jsonEncode(value)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void fetchConference(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.fetch(value.id))
        .then((value) => showDialog(context, 'Success', value.toJson().toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void current(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => showDialog(context, 'Success', value.toJson().toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void getAudioLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getAudioLevel(value.participants.first))
        .then((value) => showDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void leave(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.leave(null))
        .then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JoinConference(username: ''))))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void isMuted(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .isMuted()
        .then((value) => showDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setMute(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.mute(value.participants.first, mute))
        .then((value) => showDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void updatePermissions(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => value.participants.first)
        .then(
          (value) => _dolbyioCommsSdkFlutterPlugin.conference.updatePermissions([
            ParticipantPermissions(value, [ConferencePermission.SEND_AUDIO, ConferencePermission.SEND_VIDEO])
          ]),
        )
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setMuteOutput(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .muteOutput(mute)
        .then((value) => showDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void startAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) => _dolbyioCommsSdkFlutterPlugin.conference
        .startAudio(current.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString())));
  }

  void stopAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) => _dolbyioCommsSdkFlutterPlugin.conference
        .stopAudio(current.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString())));
  }

  void startVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) => _dolbyioCommsSdkFlutterPlugin.conference
        .startVideo(current.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString())));
  }

  void stopVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) => _dolbyioCommsSdkFlutterPlugin.conference
        .stopVideo(current.participants.first)
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString())));
  }

  void startScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((current) => _dolbyioCommsSdkFlutterPlugin.conference.startScreenShare())
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString()));
  }

  void stopScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((current) => _dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare())
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString() + stackTrace.toString()));
  }

  void setMySpatialPosition(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialPosition(null, SpatialPosition(1.0, 1.0, 1.0))
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setSpatialPosition(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.setSpatialPosition(value.first, SpatialPosition(1.0, 1.0, 1.0)))
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setSpatialEnvironment(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialEnvironment(SpatialScale(1.0, 1.0, 1.0), SpatialPosition(0.0, 0.0, 1.0), SpatialPosition(0.0, 1.0, 0.0),
            SpatialPosition(1.0, 0.0, 0.0))
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
        .then((value) => showDialog(context, 'Success', jsonEncode(value)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setMaxVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.setMaxVideoForwarding(4, value))
        .then((value) => showDialog(context, 'Success', jsonEncode(value)))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void setVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.setVideoForwarding(VideoForwardingStrategy.LAST_SPEAKER, 4, value))
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
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.isSpeaking(value.first))
        .then((value) => showDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  //Recording service
  void startRecording(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.recording
        .start()
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void stopRecording(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.recording
        .stop()
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  void currentRecording(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.recording
        .currentRecording()
        .then((value) => showDialog(context, 'Success', value.toString()))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }

  //MediaDeviceService
  void getComfortNoiseLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice.getComfortNoiseLevel()
        .then((value) => showDialog(context, "Success", value.value))
        .onError((error, stackTrace) =>
        showDialog(context, "Error", error.toString()));
  }

  void setComfortNoiseLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice.setComfortNoiseLevel(
        ComfortNoiseLevel.Medium)
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
        showDialog(context, "Error", error.toString()));
  }

  void isFrontCamera(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice.isFrontCamera()
        .then((value) => showDialog(context, "Success", value.toString()))
        .onError((error, stackTrace) =>
        showDialog(context, "Error", error.toString()));
  }

  void switchCamera(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.mediaDevice.switchCamera()
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
        showDialog(context, "Error", error.toString()));
  }

  //Command service
  void send(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.command
        .send("Test message")
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }
}
