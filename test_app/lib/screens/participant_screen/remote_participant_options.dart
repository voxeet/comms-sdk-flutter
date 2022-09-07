import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'dart:developer' as developer;

import '../../widgets/dialogs.dart';

class RemoteParticipantOptions extends StatefulWidget {
  final int index;

  const RemoteParticipantOptions({Key? key, required this.index})
      : super(key: key);

  @override
  State<RemoteParticipantOptions> createState() => _RemoteParticipantOptionsState();
}

class _RemoteParticipantOptionsState extends State<RemoteParticipantOptions> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool isRemoteMuted = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        position: PopupMenuPosition.over,
        icon: const Icon(Icons.more_vert, color: Colors.white,),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 0,
              child: ListTile(title: Text('Kick'), leading: Icon(Icons.remove, color: Colors.deepPurple),),
            ),
            PopupMenuItem<int>(
              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
              value: 1,
              child: isRemoteMuted
                  ? const ListTile(
                leading: Icon(Icons.mic_off, color: Colors.deepPurple),
                title: Text('Unmute'),
              )
                  : const ListTile(
                leading: Icon(Icons.mic, color: Colors.deepPurple),
                title: Text('Mute'),
              ),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 2,
              child: ListTile(
                title: Text('Update permissions'),
                leading: Icon(Icons.perm_camera_mic_outlined, color: Colors.deepPurple)
              )
            )
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              {
                kickParticipant(widget.index);
                break;
              }
            case 1:
              {
                muteRemoteParticipant(widget.index);
                break;
              }
            case 2:
              {
                updatePermissions(widget.index);
              }
          }
        });
  }

  void kickParticipant(int index) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((conference) {
          _dolbyioCommsSdkFlutterPlugin.conference
              .getParticipant(conference.participants[index].id)
              .then((participant) => _dolbyioCommsSdkFlutterPlugin.conference.kick(participant));
        });
  }

  void muteRemoteParticipant(int index) {
    if (isRemoteMuted == false) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .current()
          .then((conference) {
            _dolbyioCommsSdkFlutterPlugin.conference
                .getParticipant(conference.participants[index].id)
                .then((participant) => _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, true));
            setState(() => isRemoteMuted = true);
          });
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference
          .current()
          .then((conference) {
            _dolbyioCommsSdkFlutterPlugin.conference
                .getParticipant(conference.participants[index].id)
                .then((participant) => _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, false));
            setState(() => isRemoteMuted = false);
          });
    }
  }

  void updatePermissions(int index) {
    _dolbyioCommsSdkFlutterPlugin.conference.current()
        .then((conference) => conference.participants[index])
        .then((participant) => _dolbyioCommsSdkFlutterPlugin.conference.updatePermissions([
      ParticipantPermissions(participant, [ConferencePermission.sendAudio])
    ]))
        .then((value) => showDialog(context, 'Success', "OK"))
        .onError((error, stackTrace) =>
        showDialog(
            context,
            'Error',
            "$error\nThis method is only available  for protected conferences")
    );
  }

  Future<void> showDialog(BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
