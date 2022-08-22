import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/conference.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/spatial.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/dialogs.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/primary_button.dart';
import 'package:flutter/material.dart';

import 'join_conference_screen.dart';

class ParticipantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Participant Screen'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            ConferenceControlsContent(),
            DraggableScrollableSheet(
              initialChildSize: 0.15,
              minChildSize: 0.15,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: ConferenceControlsContent(),
                );
              },
            ),
          ],
        ),
      );
}

class ConferenceContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            color: Colors.red,
            child: SizedBox.fromSize(size: const Size.fromRadius(180)),
          ),
          const Text("Participant Id"),
        ],
      ),
    );
  }
}

class ConferenceControlsContent extends StatelessWidget {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PrimaryButton(
                widgetText: const Text('Leave'),
                onPressed: () => leave(context)),
            PrimaryButton(
                widgetText: const Text('get participant'),
                onPressed: () => getParticipant(context)),
            PrimaryButton(
                widgetText: const Text('get participants'),
                onPressed: () => getParticipants(context)),
            PrimaryButton(
                widgetText: const Text('fetch conference'),
                onPressed: () => fetchConference(context)),
            PrimaryButton(
                widgetText: const Text('current conference'),
                onPressed: () => current(context)),
            PrimaryButton(
                widgetText: const Text('getAudioLevel'),
                onPressed: () => getAudioLevel(context)),
            PrimaryButton(
                widgetText: const Text('isMuted'),
                onPressed: () => isMuted(context)),
            PrimaryButton(
                widgetText: const Text('Mute'),
                onPressed: () => setMute(context, true)),
            PrimaryButton(
                widgetText: const Text('Unmute'),
                onPressed: () => setMute(context, false)),
            PrimaryButton(
                widgetText: const Text('Start audio'),
                onPressed: () => startAudio(context)),
            PrimaryButton(
                widgetText: const Text('Stop audio'),
                onPressed: () => stopAudio(context)),
            PrimaryButton(
                widgetText: const Text('Start video'),
                onPressed: () => startVideo(context)),
            PrimaryButton(
                widgetText: const Text('Stop video'),
                onPressed: () => stopVideo(context)),
            PrimaryButton(
                widgetText: const Text('Start screen share'),
                onPressed: () => startScreenShare(context)),
            PrimaryButton(
                widgetText: const Text('Stop screen share'),
                onPressed: () => stopScreenShare(context)),
            PrimaryButton(
                widgetText: const Text('Set my spatial position'),
                onPressed: () => setMySpatialPosition(context)),
            PrimaryButton(
                widgetText: const Text('Set spatial position'),
                onPressed: () => setSpatialPosition(context)),
            PrimaryButton(
                widgetText: const Text('Set spatial direction'),
                onPressed: () => setSpatialDirection(context)),
            PrimaryButton(
                widgetText: const Text('Set spatial environment'),
                onPressed: () => setSpatialEnvironment(context)),
            PrimaryButton(
                widgetText: const Text('getLocalStats'),
                onPressed: () => getLocalStats(context)),
            PrimaryButton(
                widgetText: const Text('setMaxVideoForwarding'),
                onPressed: () => setMaxVideoForwarding(context)),
            PrimaryButton(
                widgetText: const Text('setAudioProcessing'),
                onPressed: () => setAudioProcessing(context)),
            PrimaryButton(
                widgetText: const Text('isSpeaking'),
                onPressed: () => isSpeaking(context)),
            PrimaryButton(
                widgetText: const Text('getComfortNoiseLevel'),
                onPressed: () => getComfortNoiseLevel(context)),
            PrimaryButton(
                widgetText: const Text('setComfortNoiseLevel'),
                onPressed: () => setComfortNoiseLevel(context)),
            PrimaryButton(
                widgetText: const Text('isFrontCamera'),
                onPressed: () => isFrontCamera(context)),
            PrimaryButton(
                widgetText: const Text('switchCamera'),
                onPressed: () => switchCamera(context)),
            PrimaryButton(
                widgetText: const Text('onMessageReceived ON'),
                onPressed: () => observeMessagesReceived(context)),
            PrimaryButton(
                widgetText: const Text('send'),
                onPressed: () => send(context)),
          ],
        ),
      ),
    );
  }

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void getParticipant(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference
            .getParticipant(value.participants.first.id))
        .then((value) =>
            showDialog(context, "Success", value.toJson().toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void getParticipants(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => showDialog(context, "Success", jsonEncode(value)))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void fetchConference(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.fetch(value.id))
        .then((value) =>
            showDialog(context, "Success", value.toJson().toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void current(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) =>
            showDialog(context, "Success", value.toJson().toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void getAudioLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference
            .getAudioLevel(value.participants.first))
        .then((value) => showDialog(context, "Success", value.toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void leave(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.leave(null))
        .then((value) => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JoinConferenceScreen())))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void isMuted(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .isMuted()
        .then((value) => showDialog(context, "Success", value.toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setMute(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference
            .mute(value.participants.first, mute))
        .then((value) => showDialog(context, "Success", value.toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void startAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .startAudio(current.participants.first)
            .then((value) => showDialog(context, "Success", "OK"))
            .onError((error, stackTrace) =>
                showDialog(context, "Error", error.toString())));
  }

  void stopAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .stopAudio(current.participants.first)
            .then((value) => showDialog(context, "Success", "OK"))
            .onError((error, stackTrace) =>
                showDialog(context, "Error", error.toString())));
  }

  void startVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .startVideo(current.participants.first)
            .then((value) => showDialog(context, "Success", "OK"))
            .onError((error, stackTrace) => showDialog(
                context, "Error", error.toString() + stackTrace.toString())));
  }

  void stopVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((current) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .stopVideo(current.participants.first)
            .then((value) => showDialog(context, "Success", "OK"))
            .onError((error, stackTrace) => showDialog(
                context, "Error", error.toString() + stackTrace.toString())));
  }

  void startScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((current) =>
            _dolbyioCommsSdkFlutterPlugin.conference.startScreenShare())
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) => showDialog(
            context, "Error", error.toString() + stackTrace.toString()));
  }

  void stopScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((current) =>
            _dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare())
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) => showDialog(
            context, "Error", error.toString() + stackTrace.toString()));
  }

  void setMySpatialPosition(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialPosition(null, SpatialPosition(1.0, 1.0, 1.0))
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setSpatialPosition(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference
            .setSpatialPosition(value.first, SpatialPosition(1.0, 1.0, 1.0)))
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setSpatialEnvironment(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialEnvironment(
            SpatialScale(1.0, 1.0, 1.0),
            SpatialPosition(0.0, 0.0, 1.0),
            SpatialPosition(0.0, 1.0, 0.0),
            SpatialPosition(1.0, 0.0, 0.0))
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setSpatialDirection(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .setSpatialDirection(SpatialDirection(1.0, 1.0, 1.0))
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void getLocalStats(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalStats()
        .then((value) => showDialog(context, "Success", jsonEncode(value)))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setMaxVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference
            .setMaxVideoForwarding(4, value))
        .then((value) => showDialog(context, "Success", jsonEncode(value)))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void setAudioProcessing(BuildContext context) {
    var senderOptions = AudioProcessingSenderOptions()..audioProcessing = true;
    var audioProcessingOptions = AudioProcessingOptions()..send = senderOptions;
    _dolbyioCommsSdkFlutterPlugin.conference
        .setAudioProcessing(audioProcessingOptions)
        .then((value) => showDialog(context, "Success", "OK"))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

  void isSpeaking(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(value))
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.isSpeaking(value.first))
        .then((value) => showDialog(context, "Success", value.toString()))
        .onError((error, stackTrace) =>
            showDialog(context, "Error", error.toString()));
  }

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

  void observeMessagesReceived(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.command.onMessageReceived().listen((params) {
      showDialog(context, params.type.value, params.body.message);
    });
  }

  void send(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.command
        .send("Test message")
        .then((value) => showDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showDialog(context, 'Error', error.toString()));
  }
}
