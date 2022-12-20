import 'package:dolbyio_comms_sdk_flutter_example/conference_ext.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/services.dart';
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
            text: 'Get local stats', onPressed: () => getLocalStats()),
        SecondaryButton(
            text: 'Set video forwarding',
            onPressed: () => setVideoForwarding(context)),
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
                    spatialPosition: spatialValuesModel.isSpatialConferenceState
                        ? spatialValuesModel.listOfParticipantSpatialValues
                            .where((element) => element.id == participant.id)
                            .first
                            .spatialPosition!
                        : spatialValuesModel.spatialPositionInNonSpatial);
              })
            ],
          ),
        );
      },
    );
  }

  Future<void> setSpatialDirectionDialog(
      BuildContext testButtonsContext) async {
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

  Future<void> setSpatialEnvironmentDialog(
      BuildContext testButtonsContext) async {
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
                spatialScaleForEnvironment:
                    spatialValuesModel.spatialScaleForEnvironment,
                forwardPositionForEnvironment:
                    spatialValuesModel.forwardPositionForEnvironment,
                upPositionForEnvironment:
                    spatialValuesModel.upPositionForEnvironment,
                rightPositionForEnvironment:
                    spatialValuesModel.rightPositionForEnvironment,
              );
            })
          ]),
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

  Future<void> setVideoForwarding(BuildContext setVideoContext) async {
    return await showDialog(
      context: setVideoContext,
      barrierDismissible: false,
      builder: (BuildContext environmentContext) {
        return AlertDialog(
          title: const Text('Set Video Forwarding'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Consumer<SpatialValuesModel>(
                builder: (context, spatialValuesModel, child) {
              return TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              );
            })
          ]),
        );
      },
    );

    // try {
    //   final value = await _dolbyioCommsSdkFlutterPlugin.conference
    //       .setVideoForwarding(VideoForwardingStrategy.lastSpeaker, 4, []);
    //   if (!mounted) return;
    //   showResultDialog(context, 'Success', jsonEncode(value));
    // } catch (error) {
    //   if (!mounted) return;
    //   showResultDialog(context, 'Error', error.toString());
    // }
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
