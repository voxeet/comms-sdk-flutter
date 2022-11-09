import 'package:dolbyio_comms_sdk_flutter_example/conference_ext.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/spatial_environment/spatial_environment_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '../../widgets/spatial_value_dialog_content.dart';
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
            text: 'Get participant', onPressed: () => getParticipant()),
        SecondaryButton(
            text: 'Get participants', onPressed: () => getParticipants()),
        SecondaryButton(
            text: 'Fetch conference', onPressed: () => fetchConference()),
        SecondaryButton(text: 'Current conference', onPressed: () => current()),
        SecondaryButton(
            text: 'GetAudioLevel', onPressed: () => getAudioLevel()),
        SecondaryButton(text: 'IsMuted', onPressed: () => isMuted()),
        SecondaryButton(text: 'Mute', onPressed: () => setMute(true)),
        SecondaryButton(text: 'Unmute', onPressed: () => setMute(false)),
        SecondaryButton(
            text: 'Mute output', onPressed: () => setMuteOutput(true)),
        SecondaryButton(
            text: 'Unmute output', onPressed: () => setMuteOutput(false)),
        SecondaryButton(text: 'Start audio', onPressed: () => startAudio()),
        SecondaryButton(text: 'Stop audio', onPressed: () => stopAudio()),
        SecondaryButton(text: 'Start video', onPressed: () => startVideo()),
        SecondaryButton(text: 'Stop video', onPressed: () => stopVideo()),
        SecondaryButton(
            text: 'Start screen share', onPressed: () => startScreenShare()),
        SecondaryButton(
            text: 'Stop screen share', onPressed: () => stopScreenShare()),
        SecondaryButton(
            text: 'Set spatial position',
            onPressed: () =>
                setSpatialValuesDialog(SpatialValueType.spatialPosition)),
        SecondaryButton(
            text: 'Set spatial direction',
            onPressed: () =>
                setSpatialValuesDialog(SpatialValueType.spatialDirection)),
        SecondaryButton(
            text: 'Set spatial environment',
            onPressed: () => setSpatialEnvironmentDialog()),
        SecondaryButton(
            text: 'Get local stats', onPressed: () => getLocalStats()),
        SecondaryButton(
            text: 'Set max video forwarding',
            onPressed: () => setMaxVideoForwarding()),
        SecondaryButton(
            text: 'Set video forwarding',
            onPressed: () => setVideoForwarding()),
        SecondaryButton(
            text: 'Set audio processing',
            onPressed: () => setAudioProcessing()),
        SecondaryButton(text: 'Is speaking', onPressed: () => isSpeaking()),
        SecondaryButton(
            text: 'Get max video forwarding',
            onPressed: () => getMaxVideoForwarding()),
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

  Future<void> getParticipant() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      if (!mounted) return;
      showResultDialog(
          context, 'Success', localParticipant.toJson().toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> getParticipants() async {
    try {
      var conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
      var participants = await _dolbyioCommsSdkFlutterPlugin.conference
          .getParticipants(conference);
      if (!mounted) return;
      showResultDialog(context, 'Success', jsonEncode(participants));
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> fetchConference() async {
    try {
      var conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
      var fetchedConference =
          await _dolbyioCommsSdkFlutterPlugin.conference.fetch(conference.id);
      if (!mounted) return;
      showResultDialog(
          context, 'Success', fetchedConference.toJson().toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> current() async {
    try {
      var conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
      if (!mounted) return;
      showResultDialog(context, 'Success', conference.toJson().toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> getAudioLevel() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      var audioLevel = await _dolbyioCommsSdkFlutterPlugin.conference
          .getAudioLevel(localParticipant);
      if (!mounted) return;
      showResultDialog(context, 'Success', audioLevel.toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> isMuted() async {
    try {
      var isMuted = await _dolbyioCommsSdkFlutterPlugin.conference.isMuted();
      if (!mounted) return;
      showResultDialog(context, 'Success', isMuted.toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setMute(bool mute) async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      var isMuted = await _dolbyioCommsSdkFlutterPlugin.conference
          .mute(localParticipant, mute);
      if (!mounted) return;
      showResultDialog(context, 'Success', isMuted.toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setMuteOutput(bool mute) async {
    try {
      var isMuted =
          await _dolbyioCommsSdkFlutterPlugin.conference.muteOutput(mute);
      if (!mounted) return;
      showResultDialog(context, 'Success', isMuted.toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> startAudio() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      await _dolbyioCommsSdkFlutterPlugin.conference
          .startAudio(localParticipant);
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopAudio() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      await _dolbyioCommsSdkFlutterPlugin.conference
          .stopAudio(localParticipant);
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> startVideo() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      await _dolbyioCommsSdkFlutterPlugin.conference
          .startVideo(localParticipant);
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopVideo() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      await _dolbyioCommsSdkFlutterPlugin.conference
          .stopVideo(localParticipant);
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> startScreenShare() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.conference.startScreenShare();
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> stopScreenShare() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare();
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setSpatialValuesDialog(SpatialValueType spatialValueType) async {
    final participant = await getLocalParticipant();
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext spatialValueDialogContext) {
        return AlertDialog(
          title: Text('Set ${spatialValueType.name}'),
          content: SpatialValueDialogContent(
              spatialValueDialogContext: spatialValueDialogContext,
              participant: participant,
              spatialValueType: spatialValueType,
              resultDialogContext: context),
        );
      },
    );
  }

  Future<Participant> getLocalParticipant() async {
    return _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
  }

  Future<void> setSpatialEnvironmentDialog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext environmentContext) {
        return AlertDialog(
          title: const Text('Set spatial environment'),
          content: SpatialEnvironmentDialogContent(
              environmentDialogContext: environmentContext,
              resultDialogContext: context),
        );
      },
    );
  }

  Future<void> getLocalStats() async {
    try {
      var rtcStatsTypes =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalStats();
      if (!mounted) return;
      showResultDialog(context, 'Success', jsonEncode(rtcStatsTypes));
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setMaxVideoForwarding() async {
    try {
      var conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
      var participants = await _dolbyioCommsSdkFlutterPlugin.conference
          .getParticipants(conference);
      var isMaxVideoForwardingSet =
          await _dolbyioCommsSdkFlutterPlugin.conference
              // ignore: deprecated_member_use
              .setMaxVideoForwarding(4, participants);
      if (!mounted) return;
      showResultDialog(context, 'Success', jsonEncode(isMaxVideoForwardingSet));
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setVideoForwarding() async {
    try {
      var value = await _dolbyioCommsSdkFlutterPlugin.conference
          .setVideoForwarding(VideoForwardingStrategy.lastSpeaker, 4, []);
      if (!mounted) return;
      showResultDialog(context, 'Success', jsonEncode(value));
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> setAudioProcessing() async {
    try {
      var senderOptions = AudioProcessingSenderOptions()
        ..audioProcessing = true;
      var audioProcessingOptions = AudioProcessingOptions()
        ..send = senderOptions;
      await _dolbyioCommsSdkFlutterPlugin.conference
          .setAudioProcessing(audioProcessingOptions);
      if (!mounted) return;
      showResultDialog(context, 'Success', 'OK');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> isSpeaking() async {
    try {
      var localParticipant =
          await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
      var isSpeaking = await _dolbyioCommsSdkFlutterPlugin.conference
          .isSpeaking(localParticipant);
      if (!mounted) return;
      showResultDialog(context, 'Success', isSpeaking.toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  Future<void> getMaxVideoForwarding() async {
    try {
      var maxVideoForwarding = await _dolbyioCommsSdkFlutterPlugin.conference
          .getMaxVideoForwarding();
      if (!mounted) return;
      showResultDialog(context, 'Success', maxVideoForwarding.toString());
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }
}
