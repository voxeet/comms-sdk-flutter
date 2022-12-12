import 'package:dolbyio_comms_sdk_flutter_example/conference_ext.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/bottom_tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/spatial_extensions/spatial_values_model.dart';
import '/widgets/conference_action_icon_button.dart';
import 'dart:developer' as developer;

typedef ParticipantConferenceStatus = void Function(
    bool closeSessionOnDeactivate);

class ConferenceControls extends StatefulWidget {
  final ParticipantConferenceStatus updateCloseSessionFlag;


  const ConferenceControls({Key? key, required this.updateCloseSessionFlag})
      : super(key: key);

  @override
  State<ConferenceControls> createState() => _ConferenceControlsState();
}

class _ConferenceControlsState extends State<ConferenceControls> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool isMicOff = false, isVideoOff = false, isScreenShareOff = true;

  @override
  Widget build(BuildContext context) {
    return BottomToolBar(children: [
      ConferenceActionIconButton(
        onPressedIcon: () {
          muteLocalParticipant();
        },
        backgroundIconColor: Colors.deepPurple,
        iconWidget: isMicOff
            ? const Icon(Icons.mic_off, size: 30)
            : const Icon(Icons.mic, size: 30),
      ),
      ConferenceActionIconButton(
        onPressedIcon: () {
          if (isVideoOff) {
            onStartVideo();
          } else {
            onStopVideo();
          }
          setState(() => isVideoOff = !isVideoOff);
        },
        backgroundIconColor: Colors.deepPurple,
        iconWidget: isVideoOff
            ? const Icon(Icons.videocam_off)
            : const Icon(Icons.videocam),
      ),
      ConferenceActionIconButton(
        iconWidget: isScreenShareOff
            ? const Icon(Icons.screen_share)
            : const Icon(Icons.stop_screen_share_sharp),
        backgroundIconColor: Colors.deepPurple,
        onPressedIcon: () {
          if (isScreenShareOff) {
            startScreenShare();
          } else {
            stopScreenShare();
          }
        },
      ),
      ConferenceActionIconButton(
        onPressedIcon: () {
          leaveConferenceDialog(context);
        },
        iconWidget: const Icon(Icons.phone),
        backgroundIconColor: Colors.red,
      ),
    ]);
  }

  Future<void> leaveConferenceDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leaving options'),
          content: const Text(
              'Do you want to close session while leaving conference?'),
          actions: <TextButton>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                widget.updateCloseSessionFlag(true);
                Provider.of<SpatialValuesModel>(context, listen: false)
                    .clearSpatialValues();
                Navigator.of(context).popUntil(
                  ModalRoute.withName("LoginScreen"),
                );
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                widget.updateCloseSessionFlag(false);
                Provider.of<SpatialValuesModel>(context, listen: false)
                    .clearSpatialValues();
                Navigator.of(context).popUntil(
                  ModalRoute.withName("JoinConferenceScreen"),
                );
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  void muteLocalParticipant() {
    if (isMicOff == false) {
      _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant().then(
          (participant) => _dolbyioCommsSdkFlutterPlugin.conference
              .mute(participant, true)
              .then(
                  (value) => developer.log('Local participant has been muted.'))
              .onError((error, stackTrace) =>
                  onError('Error during mutting.', error)));
      setState(() => isMicOff = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant().then(
          (participant) => _dolbyioCommsSdkFlutterPlugin.conference
              .mute(participant, false)
              .then((value) =>
                  developer.log('Local participant has been unmuted.'))
              .onError((error, stackTrace) =>
                  onError('Error during unmutting.', error)));
      setState(() => isMicOff = false);
    }
  }

  void onStopVideo() {
    _dolbyioCommsSdkFlutterPlugin.videoService.localVideo
        .stop()
        .then((value) =>
            developer.log('Local participant video has been stopped.'))
        .onError((error, stackTrace) =>
            onError('Error during stopping video.', error));
  }

  void onStartVideo() {
    _dolbyioCommsSdkFlutterPlugin.videoService.localVideo
        .start()
        .then((value) =>
            developer.log('Local participant video has been started.'))
        .onError((error, stackTrace) =>
            onError('Error during starting video.', error));
  }

  void startScreenShare() async {
    try {
      var isScreenSharing = await isSomeoneScreenSharing();
      if (isScreenSharing) {
        if (!mounted) return;
        showResultDialog(
            context, 'Error', 'Someone is already sharing the screen');
      } else {
        await _dolbyioCommsSdkFlutterPlugin.conference.startScreenShare();
        var isScreenSharing = await isSomeoneScreenSharing();
        if (isScreenSharing) setState(() => isScreenShareOff = false);
      }
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
  }

  void stopScreenShare() async {
    try {
      await _dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare();
      setState(() => isScreenShareOff = true);
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error', error.toString());
    }
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

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
