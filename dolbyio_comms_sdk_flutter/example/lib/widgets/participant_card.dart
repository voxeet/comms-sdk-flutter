import 'package:dolbyio_comms_sdk_flutter_example/widgets/native_view.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';

class ParticipantCard extends StatefulWidget {
  final String participantName;
  int? participantId;
  final List<Participant> participants;
  void Function(String id) onKickPressed;

  ParticipantCard({
    Key? key,
    required this.participants,
    required this.participantName,
    required this.participantId,
    required this.onKickPressed,
  }) : super(key: key);

  @override
  _ParticipantCardState createState() => _ParticipantCardState();
}

class _ParticipantCardState extends State<ParticipantCard> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool isMicCardOff = false;
  final String viewType = 'view1';
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.all(12),
              child: isMicCardOff
                  ? const Icon(Icons.mic_off, color: Colors.white)
                  : const Icon(Icons.mic, color: Colors.white)),
          Expanded(
            child: AndroidView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec()
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Text(
                  style: const TextStyle(color: Colors.white),
                  widget.participantName,
                  maxLines: 1,
                ),
              ),
              PopupMenuButton(
                  position: PopupMenuPosition.over,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<int>(
                          textStyle:
                              TextStyle(fontSize: 14, color: Colors.black),
                          value: 0,
                          child: Text("Kick")),
                      PopupMenuItem<int>(
                        textStyle: TextStyle(fontSize: 14, color: Colors.black),
                        value: 1,
                        child: isMicCardOff ? Text("Unmute") : Text("Mute"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        {
                          if (widget.participantId != 0) {
                            widget
                                .onKickPressed(widget.participantId.toString());
                          } else {
                            developer.log(
                                "You cannot kick yourself from conference, use leave button instead..");
                          }
                          break;
                        }
                      case 1:
                        {
                          if (widget.participantId != 0) {
                            muteRemoteParticipant(
                                widget.participantId.toString());
                          } else {
                            developer.log(
                                "You cannot mute yourself, use mic icon on bottom instead.");
                          }
                          break;
                        }
                    }
                  }),
            ],
          )
        ]));
  }

  void muteRemoteParticipant(String participantId) {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((conference) {
      if (isMicCardOff) {
        _dolbyioCommsSdkFlutterPlugin.conference
            .mute(widget.participants.elementAt(int.parse(participantId)),
                isMicCardOff)
            .then((value) => _dolbyioCommsSdkFlutterPlugin.conference
                .startAudio(
                    widget.participants.elementAt(int.parse(participantId)))
            .onError((error, stackTrace) =>
            onStartAudioParticipantError(error)));
      } else {
        _dolbyioCommsSdkFlutterPlugin.conference
            .mute(widget.participants.elementAt(int.parse(participantId)),
                isMicCardOff)
            .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.stopAudio(
                widget.participants.elementAt(int.parse(participantId)))
        .onError((error, stackTrace) => null));
      }
      setState(() => isMicCardOff = !isMicCardOff);
    });
  }

  void onStartAudioParticipantError(Object? error) {
    developer.log("Error during starting audio of participant.", error: error);
  }

  void onStopAudioParticipantError(Object? error) {
    developer.log("Error during stopping audio of participant.", error: error);
  }
}
