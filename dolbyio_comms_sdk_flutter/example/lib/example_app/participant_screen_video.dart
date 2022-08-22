import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/conference_action_icon_button.dart';

class ParticipantScreenVideo extends StatefulWidget {
  @override
  _ParticipantScreenVideoState createState() => _ParticipantScreenVideoState();
}

class _ParticipantScreenVideoState extends State<ParticipantScreenVideo> {

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  final VideoViewController _localParticipantVideoViewController = VideoViewController();

  List<Participant> participants = [];
  String conferenceName = '';
  String participantName = '';
  bool isMicOff = false;
  bool isVideoOff = false;
  bool isRemoteMuted = false;

  List<StreamSubscription<dynamic>> subscriptions = [];

  @override
  void initState() {
    super.initState();
    getCurrentConferenceName();
    initParticipantsList();

    subscriptions.add(_dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange()
      .listen((params) {
        initParticipantsList();
        updateLocalView();
        developer.log("onParticipantsChange");
      })
    );

    _dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange().listen((params) {
      developer.log("onParticipantsChange2");
    });

    subscriptions.add(_dolbyioCommsSdkFlutterPlugin.conference.onStreamsChange().listen((params) {  
      updateLocalView();
      developer.log("onStreamsChange");
    }));

    _dolbyioCommsSdkFlutterPlugin.conference.onStatusChange().listen((params) {
      developer.log("onStatusChange");
    });
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        leaveConference();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Participant Screen'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ConferenceName(conferenceName: conferenceName), 
            buildParticipantView(), 
            buildConferenceControls()
          ],
        ),
      )
    );

  Expanded buildParticipantView() {
    return Expanded(
      child: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: participants.length,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                mainAxisSpacing: 12, 
                crossAxisSpacing: 12
              ),
              itemBuilder: (context, index) {
                return VideoViewTile(
                  participant: participants[index],
                  remoteParticipantOptions: buildRemoteParticipantOptions(index),
                );
              }
            )
          ),

          Positioned(
            left: 10, bottom: 10,
            width: 100, height: 140,
            child: Container(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: VideoView(videoViewController: _localParticipantVideoViewController),
            )
          ),
        ]
      )
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
          Expanded(
              child: ConferenceActionIconButton(
            onPressedIcon: () {
              muteLocalParticipant();
            },
            backgroundIconColor: Colors.blue,
            iconWidget: isMicOff ? const Icon(Icons.mic_off, size: 30) : const Icon(Icons.mic, size: 30),
          )),
          Expanded(
              child: ConferenceActionIconButton(
            onPressedIcon: () {
              if (isVideoOff) {
                onStartVideo();
              } else {
                onStopVideo();
              }
              setState(() => isVideoOff = !isVideoOff);
            },
            backgroundIconColor: Colors.blue,
            iconWidget: isVideoOff ? const Icon(Icons.videocam_off) : const Icon(Icons.videocam),
          )),
          Expanded(
            child: ConferenceActionIconButton(
                onPressedIcon: () {
                  leaveConference();
                },
                iconWidget: const Icon(Icons.phone),
                backgroundIconColor: Colors.red),
          ),
        ],
      ),
    );
  }

  PopupMenuButton? buildRemoteParticipantOptions(int index) {
    if (index == 0) {
      return null;
    }
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

  String getCurrentConferenceName() {
    _dolbyioCommsSdkFlutterPlugin.conference.current().then((conference) {
      setState(() => conferenceName = conference.alias.toString());
    }).onError((error, stackTrace) {
      onGetCurrentConferenceError(error);
    });
    return conferenceName;
  }

  Future<void> initParticipantsList() async {

    final currentConference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(currentConference);
    final availableParticipants 
      = conferenceParticipants.where((element) => element.status != ParticipantStatus.LEFT);
    developer.log('initParticipantsList(): Setting participants with ids: ${availableParticipants.map((e) => e.id).toList()}');
    setState(() => participants = availableParticipants.toList());
    return Future.value();
  }

  Future<void> updateLocalView() async {
    final currentConference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(currentConference);
    final availableParticipants 
      = conferenceParticipants.where((element) => element.status != ParticipantStatus.LEFT);
    developer.log('updateLocalView(): Available participants with ids: ${availableParticipants.map((e) => e.id).toList()}');
    if (participants.isNotEmpty) {
      developer.log('updateLocalView(): Setting up local participant view');
      final localParticipant = participants.first;
      final streams = localParticipant.streams;
      MediaStream? stream;
      if (streams != null) {
        for (final s in streams) {
          if (s.type == MediaStreamType.Camera) {
            stream = s;
            break;
          }
        }
      }
      if (stream != null) {
        await _localParticipantVideoViewController.attach(localParticipant, stream);
      } else {
        _localParticipantVideoViewController.detach();
      }
      developer.log('updateLocalView(): Stream is attached: ${await _localParticipantVideoViewController.isAttached()}');
    }
    return Future.value();
  }

  void kickParticipant(int index) {
    // TODO change to kick() method when it'll be implemented
  }

  void muteRemoteParticipant(int participantIndex) {
    if (isRemoteMuted == false) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.elementAt((participantIndex)), true)
          .then((value) => developer.log('Remote participant has been muted'))
          .onError((error, stackTrace) => onMuteParticipantError(error));
      setState(() => isRemoteMuted = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.elementAt(participantIndex), false)
          .then((value) => developer.log('Remote participant has been unmuted'))
          .onError((error, stackTrace) => onMuteParticipantError(error));
      setState(() => isRemoteMuted = false);
    }
  }

  void muteLocalParticipant() {
    if (isMicOff == false) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.first, true)
          .then((value) => developer.log('Local participant has been muted.'))
          .onError((error, stackTrace) => onMuteParticipantError(error));
      setState(() => isMicOff = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference
          .mute(participants.first, false)
          .then((value) => developer.log('Local participant has been unmuted.'))
          .onError((error, stackTrace) => onUnMuteParticipantError(error));
      setState(() => isMicOff = false);
    }
  }

  void onStopVideo() {
    _dolbyioCommsSdkFlutterPlugin.conference
        .stopVideo(participants.first)
        .then((value) => developer.log('Local participant video has been stopped.'))
        .onError((error, stackTrace) => onStopVideoParticipantError(error));
  }

  void onStartVideo() {
    _dolbyioCommsSdkFlutterPlugin.conference
        .startVideo(participants.first)
        .then((value) => developer.log('Local participant video has been started.'))
        .onError((error, stackTrace) => onStartVideoParticipantError(error));
  }

  void leaveConference() {
    var leaveOptions = ConferenceLeaveOptions(false);
    _dolbyioCommsSdkFlutterPlugin.conference.leave(leaveOptions).then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      developer.log('Conference left.');
    }).onError((error, stackTrace) {
      onLeaveConferenceError(error);
    });
  }

  void onGetCurrentConferenceError(Object? error) {
    developer.log('Error during getting current conference name.', error: error);
  }

  void onInitParticipantsListError(Object? error) {
    developer.log('Error during initializing participants list.', error: error);
  }

  void onGetParticipantNameError(Object? error) {
    developer.log('Error during getting participant name.', error: error);
  }

  void onKickParticipantError(Object? error) {
    developer.log('Error during kicking participant.', error: error);
  }

  void onMuteParticipantError(Object? error) {
    developer.log('Error during muting participant.', error: error);
  }

  void onUnMuteParticipantError(Object? error) {
    developer.log('Error during muting participant.', error: error);
  }

  void onStartAudioParticipantError(Object? error) {
    developer.log('Error during starting audio of participant.', error: error);
  }

  void onStopAudioParticipantError(Object? error) {
    developer.log('Error during stopping audio of participant.', error: error);
  }

  void onStartVideoParticipantError(Object? error) {
    developer.log('Error during starting video of participant.', error: error);
  }

  void onStopVideoParticipantError(Object? error) {
    developer.log('Error during stopping video of participant.', error: error);
  }

  void onLeaveConferenceError(Object? error) {
    developer.log('Error during leaving conference.', error: error);
  }
}

class ConferenceName extends StatelessWidget {
  const ConferenceName({
    Key? key,
    required this.conferenceName,
  }) : super(key: key);

  final String conferenceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        conferenceName,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

class VideoViewTile extends StatelessWidget {

  final Participant participant;
  final Widget? remoteParticipantOptions;

  VideoViewTile({required this.participant, this.remoteParticipantOptions});

  @override
  Widget build(BuildContext context) {
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
          )
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12), 
                bottomRight: Radius.circular(12)
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    participant.info!.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (remoteParticipantOptions != null) remoteParticipantOptions!
              ],
            ),
          )
        ),
      ],
    );
  }
}
