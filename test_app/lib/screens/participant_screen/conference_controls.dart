import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/conference_action_icon_button.dart';
import 'dart:developer' as developer;

class ConferenceControls extends StatefulWidget {
  final Future<Conference?> conference;

  const ConferenceControls({Key? key, required this.conference}) : super(key: key);

  @override
  State<ConferenceControls> createState() => _ConferenceControlsState();
}

class _ConferenceControlsState extends State<ConferenceControls> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool isMicOff = false, isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 0.8)]
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConferenceActionIconButton(
                onPressedIcon: () { muteLocalParticipant(); },
                backgroundIconColor: Colors.deepPurple,
                iconWidget: isMicOff ? const Icon(Icons.mic_off, size: 30) : const Icon(Icons.mic, size: 30),
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
                iconWidget: isVideoOff ? const Icon(Icons.videocam_off) : const Icon(Icons.videocam),
              ),
              ConferenceActionIconButton(
                  onPressedIcon: () { leaveConferenceDialog(context); },
                  iconWidget: const Icon(Icons.phone),
                  backgroundIconColor: Colors.red
              ),
            ]
        )
    );
  }

  Future<void> leaveConferenceDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leaving options'),
          content: const Text('Do you want to close session while leaving conference?'),
          actions: <TextButton>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                leaveConference(closeSession: true);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                leaveConference(closeSession: false);
                Navigator.of(context).pop();
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

  void muteLocalParticipant() {
    if (isMicOff == false) {
      widget.conference.then((current) {
        _dolbyioCommsSdkFlutterPlugin.conference
            .mute(current!.participants.first, true)
            .then((value) => developer.log('Local participant has been muted.'))
            .onError((error, stackTrace) => onError('Error during mutting.', error));
      });
      setState(() => isMicOff = true);
    } else {
        widget.conference.then((current) {
          _dolbyioCommsSdkFlutterPlugin.conference
          .mute(current!.participants.first, false)
          .then((value) => developer.log('Local participant has been unmuted.'))
          .onError((error, stackTrace) => onError('Error during unmutting.', error));
      });
      setState(() => isMicOff = false);
    }
  }

  void onStopVideo() {
    widget.conference.then((current) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .stopVideo(current!.participants.first)
          .then((value) => developer.log('Local participant video has been stopped.'))
          .onError((error, stackTrace) => onError('Error during stopping video.', error));
    });
  }

  void onStartVideo() {
    widget.conference.then((current) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .startVideo(current!.participants.first)
          .then((value) => developer.log('Local participant video has been started.'))
          .onError((error, stackTrace) => onError('Error during starting video.', error));
    });
  }

  void leaveConference({required bool closeSession})  {
    if(closeSession) {
        var options = ConferenceLeaveOptions(true);
        _dolbyioCommsSdkFlutterPlugin.conference
            .leave(options: options)
            .then((value) {
              Navigator.of(context).popUntil(ModalRoute.withName("LoginScreen"));
            })
            .onError((error, stackTrace) { onError('Error during leaving', error); });
      } else {
        var options = ConferenceLeaveOptions(false);
        widget.conference.then((current) {
          _dolbyioCommsSdkFlutterPlugin.conference
              .leave(options: options)
              .then((value) {
                Navigator.of(context).popUntil(ModalRoute.withName("JoinConferenceScreen"));
              })
              .onError((error, stackTrace) {onError('Error during leaving', error);});
        });
      }
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
