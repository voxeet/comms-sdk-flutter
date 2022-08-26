import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/example_app/join_screen.dart';
import '/example_app/login_screen.dart';
import '/example_app/participant_screen.dart';
import 'conference_action_icon_button.dart';
import 'dart:developer' as developer;
import 'dialogs.dart';

class ConferenceControls extends StatefulWidget {
  final Future<Conference?> conference;

  ConferenceControls({Key? key, required this.conference}) : super(key: key);

  @override
  State<ConferenceControls> createState() => _ConferenceControlsState();
}

class _ConferenceControlsState extends State<ConferenceControls> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool sessionShouldBeClose = false, isMicOff = false, isVideoOff = false;

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
                  onPressedIcon: () { leaveConference(); },
                  iconWidget: const Icon(Icons.phone),
                  backgroundIconColor: Colors.red
              ),
            ]
        )
    );
  }

  Future<void> showClosingSessionDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
        context: context,
        title: title,
        body: text,
        okText: "Yes",
        cancelText: "No",
        result: (value) { setState(() => sessionShouldBeClose = value); }
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

  void leaveConference() async {
    await showClosingSessionDialog(context, 'Do you want to close the session?', '');
    if(sessionShouldBeClose) {
      var options = ConferenceLeaveOptions(true);
      _dolbyioCommsSdkFlutterPlugin.conference
          .leave(options: options)
          .then((value) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              const LoginScreen())
            );
          })
          .onError((error, stackTrace) { onError('Error during leaving', error); });
    } else {
      var options = ConferenceLeaveOptions(false);
      widget.conference.then((current) {
        _dolbyioCommsSdkFlutterPlugin.conference
            .leave(options: options)
            .then((value) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                JoinConference(username: current!.participants.first.info!.name)
              ));
            })
            .onError((error, stackTrace) { onError('Error during leaving', error); });
      });
    }
  }
}
