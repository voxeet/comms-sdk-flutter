import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/participant.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/streams.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/view/video_view.dart';
import '../widgets/conference_action_icon_button.dart';
import '../widgets/dialogs.dart';
import '../widgets/dolby_title.dart';
import '../widgets/test_buttons.dart';

class ParticipantScreenRN extends StatefulWidget {
  const ParticipantScreenRN({Key? key}) : super(key: key);

  @override
  State<ParticipantScreenRN> createState() => _ParticipantScreenRNState();
}

Future<void> showDialog(
    BuildContext context, String title, String text) async {
  await ViewDialogs.dialog(
    context: context,
    title: title,
    body: text,
  );
}

class _ParticipantScreenRNState extends State<ParticipantScreenRN> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  String participantName = '';
  String conferenceName = '';
  List<Participant> participants = [];
  bool isRemoteMuted = false;
  bool isVideoOff = false;
  bool isMicOff = false;

  @override
  void initState() {
    super.initState();
    getCurrentConferenceName();
    initParticipantsList();

    _dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange().listen((params) {
      initParticipantsList();
      developer.log("onParticipantsChange");
    });

    _dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange().listen((params) {
      developer.log("onParticipantsChange2");
    });

    _dolbyioCommsSdkFlutterPlugin.conference.onStreamsChange().listen((params) {
      developer.log("onStreamsChange");
    });

    _dolbyioCommsSdkFlutterPlugin.conference.onStatusChange().listen((params) {
      developer.log("onStatusChange");
    });

    _dolbyioCommsSdkFlutterPlugin.command.onMessageReceived().listen((params) {
      showDialog(context, params.type.value, "Message: ${params.body.message}");
      developer.log("onMessageReceived");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          leaveConference();
          return false;
        },
        child: SafeArea(
          left: false,
          right: false,
          child: Scaffold(
                body: Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: const BoxDecoration(color: Colors.deepPurple),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK',),
                        Expanded(
                            child: Container(
                                alignment: Alignment.bottomCenter,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12))),
                                    child: Column(
                                      children: [
                                        buildConferenceName(),
                                        buildParticipantView(),
                                        buildButtonShowBottomModalSheet(),
                                        buildConferenceControls(),
                                      ],
                                    ),
                                  ),
                                )
                      ]),
                ),
              ),
        )
    );
  }
  
  Widget buildConferenceName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        conferenceName,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Expanded buildParticipantView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
            itemCount: participants.length,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
            itemBuilder: (context, index) {
              var participant = participants[index];
              return Column(
                children: [
                  Expanded(
                    flex: 5, 
                    child: VideoView.forList(
                      participant: participant, 
                      key: ValueKey('video_view_tile_${participant.id}'),
                      mediaStreamSelector: (streams) {
                        MediaStream? stream;
                        if (streams != null) {
                          for (final s in streams) {
                            if (s.type == MediaStreamType.Camera) {
                              stream = s;
                              break;
                            }
                          }
                        }
                        return stream;
                      }
                    )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius:
                                BorderRadius.vertical(bottom: Radius.circular(12))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                getParticipantName(index),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            if (index != 0) buildRemoteParticipantOptions(index)
                          ],
                        ),
                      ))
                ],
              );
            }),
      ),
    );
  }

  Widget buildRemoteParticipantOptions(int index) {
    return PopupMenuButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.only(bottom: 4, top: 4),
        position: PopupMenuPosition.over,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 0,
              child: ListTile(
                title: Text('Kick'),
                leading: Icon(
                  Icons.remove,
                  color: Colors.blue,
                ),
              ),
            ),
            PopupMenuItem<int>(
              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
              value: 1,
              child: !isRemoteMuted
                  ? const ListTile(
                      leading: Icon(Icons.mic, color: Colors.blue),
                      title: Text('Mute'),
                    )
                  : const ListTile(
                      leading: Icon(Icons.mic_off, color: Colors.blue),
                      title: Text('Unmute'),
                    ),
            ),
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              {
                // TODO invoke kickParticipant() method
                break;
              }
            case 1:
              {
                muteRemoteParticipant(index);
                break;
              }
          }
        });
  }

  Widget buildButtonShowBottomModalSheet(){
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.touch_app),
          onPressed: () =>
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  context: context,
                  builder: (context) { return FractionallySizedBox(
                    heightFactor: 0.8,
                    child: TestButtons(),
                  );
                  }
              ),
        ),
      ),
    );
  }

  Container buildConferenceControls() {
    return Container(
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 0.8)]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ConferenceActionIconButton(
                onPressedIcon: () {
                  muteLocalParticipant();
                },
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
                  onPressedIcon: () {
                    leaveConference();
                  },
                  iconWidget: const Icon(Icons.phone),
                  backgroundIconColor: Colors.red),
            ]));
  }

  String getCurrentConferenceName() {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((conference) {
      setState(() => conferenceName = conference.alias.toString());
    }).onError((error, stackTrace) {
      onError('Error during getting conference name.', error);
    });
    return conferenceName;
  }

  String getParticipantName(int id) {
    participantName = participants.elementAt(id).info!.name;
    return participantName;
  }

  List<Participant> initParticipantsList() {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((conference) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .getParticipants(conference)
            .then((participantsList) {
          setState(
              () => participants = checkActiveParticipants(participantsList));
        }).onError((error, stackTrace) {
          onError('Error during initializing participants list.', error);
        }));
    return participants;
  }

  List<Participant> checkActiveParticipants(
      List<Participant> participantsList) {
    List<Participant> activeParticipants = [];
    for (var participant in participantsList) {
      var participantStatus = participant.status?.name;
      developer.log("STATUS: $participantStatus");
      if (participantStatus == "LEFT") {
        activeParticipants.remove(participant);
      } else {
        activeParticipants.add(participant);
      }
    }
    return activeParticipants;
  }

  void muteRemoteParticipant(int participantIndex) {
    if (isRemoteMuted == false) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.elementAt((participantIndex)), true)
          .then((value) => developer.log('Remote participant has been muted'))
          .onError((error, stackTrace) =>
              onError('Error during mutting remote participant', error));
      setState(() => isRemoteMuted = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.elementAt(participantIndex), false)
          .then((value) => developer.log('Remote participant has been unmuted'))
          .onError((error, stackTrace) =>
              onError('Error during unmutting remote participant', error));
      setState(() => isRemoteMuted = false);
    }
  }

  void kickParticipant() {
    // TODO change to kick() method when it'll be implemented
  }

  void leaveConference() {
    var leaveOptions = ConferenceLeaveOptions(false);
    _dolbyioCommsSdkFlutterPlugin.conference.leave(leaveOptions).then((value) {
      Navigator.of(context).pop();
      developer.log('Conference left.');
    }).onError((error, stackTrace) {
      onError('Error during leaving conference.', error);
    });
  }

  void muteLocalParticipant() {
    if (isMicOff == false) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.first, true)
          .then((value) => developer.log('Local participant has been muted.'))
          .onError((error, stackTrace) => onError('', error));
      setState(() => isMicOff = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.first, false)
          .then((value) => developer.log('Local participant has been unmuted.'))
          .onError((error, stackTrace) => onError('', error));
      setState(() => isMicOff = false);
    }
  }

  void onStopVideo() {
    _dolbyioCommsSdkFlutterPlugin.conference
        .stopVideo(participants.first)
        .then((value) => developer.log('Local participant video has been stopped.'))
        .onError((error, stackTrace) => onError('', error));
  }

  void onStartVideo() {
    _dolbyioCommsSdkFlutterPlugin.conference
        .startVideo(participants.first)
        .then((value) => developer.log('Local participant video has been started.'))
        .onError((error, stackTrace) => onError('', error));
  }

  bool _hasAvailableStream(List<MediaStream>? streams) {
    return streams != null &&
        streams.isNotEmpty &&
        streams[0].videoTracks.isNotEmpty;
  }

  void _prepareVideo(
      VideoView videoView, Participant participant, bool isAttached) {
    if (!isAttached) {
      if (_hasAvailableStream(participant.streams)) {
        var stream = participant.streams
            ?.firstWhere((element) => element.type == MediaStreamType.Camera);
        // videoView.attach(participant, stream);
      }
    } else {
      // videoView.detach();
    }
  }
}

void onError(String message, Object? error) {
  developer.log(message, error: error);
}
