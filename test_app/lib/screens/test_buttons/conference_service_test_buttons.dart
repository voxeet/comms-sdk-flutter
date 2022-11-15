import 'package:dolbyio_comms_sdk_flutter_example/conference_ext.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/spatial_extensions/spatial_direction_dialog_content.dart';
import '../../widgets/spatial_extensions/spatial_environment_dialog_content.dart';
import '../../widgets/spatial_extensions/spatial_position_dialog_content.dart';
import '../../widgets/spatial_extensions/spatial_values_model.dart';
import '/widgets/secondary_button.dart';
import '/widgets/dialogs.dart';
import 'dart:convert';

class ConferenceServiceTestButtons extends StatefulWidget {
  const ConferenceServiceTestButtons({Key? key}) : super(key: key);

  @override
  State<ConferenceServiceTestButtons> createState() {
    return _ConferenceServiceTestButtonsState();
  }
}

class _ConferenceServiceTestButtonsState
    extends State<ConferenceServiceTestButtons> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Widget>[
        SecondaryButton(
            text: 'Get participant', onPressed: () => getParticipant(context)),
        SecondaryButton(
            text: 'Get participants',
            onPressed: () => getParticipants(context)),
        SecondaryButton(
            text: 'Fetch conference',
            onPressed: () => fetchConference(context)),
        SecondaryButton(
            text: 'Current conference', onPressed: () => current(context)),
        SecondaryButton(
            text: 'GetAudioLevel', onPressed: () => getAudioLevel(context)),
        SecondaryButton(text: 'IsMuted', onPressed: () => isMuted(context)),
        SecondaryButton(text: 'Mute', onPressed: () => setMute(context, true)),
        SecondaryButton(
            text: 'Unmute', onPressed: () => setMute(context, false)),
        SecondaryButton(
            text: 'Mute output', onPressed: () => setMuteOutput(context, true)),
        SecondaryButton(
            text: 'Unmute output',
            onPressed: () => setMuteOutput(context, false)),
        SecondaryButton(
            text: 'Start audio', onPressed: () => startAudio(context)),
        SecondaryButton(
            text: 'Stop audio', onPressed: () => stopAudio(context)),
        SecondaryButton(
            text: 'Start video', onPressed: () => startVideo(context)),
        SecondaryButton(
            text: 'Stop video', onPressed: () => stopVideo(context)),
        SecondaryButton(
            text: 'Start screen share',
            onPressed: () => startScreenShare()),
        SecondaryButton(
            text: 'Stop screen share',
            onPressed: () => stopScreenShare(context)),
        SecondaryButton(
            text: 'Set spatial position',
            onPressed: () => setSpatialPositionDialog(context)),
        SecondaryButton(
            text: 'Set spatial direction',
            onPressed: () => setSpatialDirectionDialog(context)),
        SecondaryButton(
            text: 'Set spatial environment',
            onPressed: () => setSpatialEnvironmentDialog(context)),
        SecondaryButton(
            text: 'Get local stats', onPressed: () => getLocalStats(context)),
        SecondaryButton(
            text: 'Set max video forwarding',
            onPressed: () => setMaxVideoForwarding(context)),
        SecondaryButton(
            text: 'Set video forwarding',
            onPressed: () => setVideoForwarding(context)),
        SecondaryButton(
            text: 'Set audio processing',
            onPressed: () => setAudioProcessing(context)),
        SecondaryButton(
            text: 'Is speaking', onPressed: () => isSpeaking(context)),
        SecondaryButton(
            text: 'Get max video forwarding',
            onPressed: () => getMaxVideoForwarding(context)),
      ],
    );
  }

  Future<void> showResultDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void getParticipant(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalParticipant()
        .then((participant) => showResultDialog(
            context, 'Success', participant.toJson().toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void getParticipants(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference
            .getParticipants(conference))
        .then((participants) =>
            showResultDialog(context, 'Success', jsonEncode(participants)))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void fetchConference(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) =>
            _dolbyioCommsSdkFlutterPlugin.conference.fetch(conference.id))
        .then((conference) => showResultDialog(
            context, 'Success', conference.toJson().toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void current(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => showResultDialog(
            context, 'Success', conference.toJson().toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void getAudioLevel(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalParticipant()
        .then((participant) =>
            _dolbyioCommsSdkFlutterPlugin.conference.getAudioLevel(participant))
        .then((audioLevel) =>
            showResultDialog(context, 'Success', audioLevel.toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void isMuted(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .isMuted()
        .then((isMuted) =>
            showResultDialog(context, 'Success', isMuted.toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void setMute(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalParticipant()
        .then((participant) =>
            _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, mute))
        .then((isMuted) =>
            showResultDialog(context, 'Success', isMuted.toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void setMuteOutput(BuildContext context, bool mute) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .muteOutput(mute)
        .then((isMuted) =>
            showResultDialog(context, 'Success', isMuted.toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void startAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant().then(
        (participant) => _dolbyioCommsSdkFlutterPlugin.conference
            .startAudio(participant)
            .then((value) => showResultDialog(context, 'Success', 'OK'))
            .onError((error, stackTrace) =>
                showResultDialog(context, 'Error', error.toString())));
  }

  void stopAudio(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant().then(
        (participant) => _dolbyioCommsSdkFlutterPlugin.conference
            .stopAudio(participant)
            .then((value) => showResultDialog(context, 'Success', 'OK'))
            .onError((error, stackTrace) =>
                showResultDialog(context, 'Error', error.toString())));
  }

  void startVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant().then(
        (participant) => _dolbyioCommsSdkFlutterPlugin.conference
            .startVideo(participant)
            .then((value) => showResultDialog(context, 'Success', 'OK'))
            .onError((error, stackTrace) => showResultDialog(
                context, 'Error', error.toString() + stackTrace.toString())));
  }

  void stopVideo(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant().then(
        (participant) => _dolbyioCommsSdkFlutterPlugin.conference
            .stopVideo(participant)
            .then((value) => showResultDialog(context, 'Success', 'OK'))
            .onError((error, stackTrace) => showResultDialog(
                context, 'Error', error.toString() + stackTrace.toString())));
  }

  Future<void> startScreenShare() async {
    try {
      var isScreenSharing = await isSomeoneScreenSharing();
      if (isScreenSharing) {
        if (!mounted) return;
        showResultDialog(context, 'Error', 'Someone is already sharing the screen');
      } else {
        await _dolbyioCommsSdkFlutterPlugin.conference.startScreenShare();
        if (!mounted) return;
        showResultDialog(context, 'Success', 'OK');
      }
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  void stopScreenShare(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) =>
            _dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare())
        .then((value) => showResultDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) => showResultDialog(
            context, 'Error', error.toString() + stackTrace.toString()));
  }

  Future<void> setSpatialPositionDialog(BuildContext testButtonsContext) async {
    final participant = await getLocalParticipant();
    return await showDialog(
      context: testButtonsContext,
      barrierDismissible: false,
      builder: (BuildContext spatialPositionDialogContext) {
        return AlertDialog(
          title: const Text('Set Spatial Position'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<SpatialValuesModel>(
                  builder: (context, spatialValuesModel, child) {
                return SpatialPositionDialogContent(
                    spatialValueDialogContext: spatialPositionDialogContext,
                    participant: participant,
                    resultDialogContext: testButtonsContext,
                    spatialPosition: spatialValuesModel
                        .listOfParticipantSpatialValues
                        .where((element) => element.id == participant.id)
                        .first
                        .spatialPosition!);
              })
            ],
          ),
        );
      },
    );
  }

  Future<void> setSpatialDirectionDialog(BuildContext testButtonsContext) async {
    final participant = await getLocalParticipant();
    return await showDialog(
      context: testButtonsContext,
      barrierDismissible: false,
      builder: (BuildContext spatialDirectionDialogContext) {
        return AlertDialog(
          title: const Text('Set Spatial Direction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<SpatialValuesModel>(
                  builder: (context, spatialValuesModel, child) {
                return SpatialDirectionDialogContent(
                    spatialValueDialogContext: spatialDirectionDialogContext,
                    participant: participant,
                    resultDialogContext: testButtonsContext,
                    spatialDirection: spatialValuesModel.localSpatialDirection);
              })
            ],
          ),
        );
      },
    );
  }

  Future<Participant> getLocalParticipant() async {
    return _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
  }

  Future<void> setSpatialEnvironmentDialog(BuildContext testButtonsContext) async {
    return await showDialog(
      context: testButtonsContext,
      barrierDismissible: false,
      builder: (BuildContext environmentContext) {
        return AlertDialog(
          title: const Text('Set spatial environment'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Consumer<SpatialValuesModel>(
                builder: (context, spatialValuesModel, child) {
              return SpatialEnvironmentDialogContent(
                environmentDialogContext: environmentContext,
                resultDialogContext: testButtonsContext,
                spatialScaleForEnvironment: spatialValuesModel.spatialScaleForEnvironment,
                forwardPositionForEnvironment: spatialValuesModel.forwardPositionForEnvironment,
                upPositionForEnvironment: spatialValuesModel.upPositionForEnvironment,
                rightPositionForEnvironment: spatialValuesModel.rightPositionForEnvironment,

              );
            })
          ]),
        );
      },
    );
  }

  void getLocalStats(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalStats()
        .then((rtcStatsTypes) =>
            showResultDialog(context, 'Success', jsonEncode(rtcStatsTypes)))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void setMaxVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference
            .getParticipants(conference))
        .then((participants) => _dolbyioCommsSdkFlutterPlugin.conference
            // ignore: deprecated_member_use
            .setMaxVideoForwarding(4, participants))
        .then(
            (value) => showResultDialog(context, 'Success', jsonEncode(value)))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  Future<void> setVideoForwarding(BuildContext context) async {
    try {
      final value = await _dolbyioCommsSdkFlutterPlugin.conference
          .setVideoForwarding(VideoForwardingStrategy.lastSpeaker, 4, []);
      if (!mounted) return;
      showResultDialog(context, 'Success', jsonEncode(value));
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  void setAudioProcessing(BuildContext context) {
    var senderOptions = AudioProcessingSenderOptions()..audioProcessing = true;
    var audioProcessingOptions = AudioProcessingOptions()..send = senderOptions;
    _dolbyioCommsSdkFlutterPlugin.conference
        .setAudioProcessing(audioProcessingOptions)
        .then((value) => showResultDialog(context, 'Success', 'OK'))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void isSpeaking(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getLocalParticipant()
        .then((participant) =>
            _dolbyioCommsSdkFlutterPlugin.conference.isSpeaking(participant))
        .then((isSpeaking) =>
            showResultDialog(context, 'Success', isSpeaking.toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  void getMaxVideoForwarding(BuildContext context) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .getMaxVideoForwarding()
        .then((maxVideoForwarding) =>
            showResultDialog(context, 'Success', maxVideoForwarding.toString()))
        .onError((error, stackTrace) =>
            showResultDialog(context, 'Error', error.toString()));
  }

  Future<bool> isSomeoneScreenSharing() async {
    final conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
    final participants = await _dolbyioCommsSdkFlutterPlugin.conference
        .getParticipants(conference);
    final availableParticipants = participants
        .where((element) => element.status != ParticipantStatus.left);

    if (availableParticipants.isNotEmpty) {
      for (var participant in availableParticipants) {
        var participantStreams = participant.streams;
        if (participantStreams != null) {
          for (var stream in participantStreams) {
            if (stream.type == MediaStreamType.screenShare) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }
}
