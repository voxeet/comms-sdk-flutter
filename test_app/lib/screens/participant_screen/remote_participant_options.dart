import 'spatial_position_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'permissions_list.dart';
import '/widgets/dialogs.dart';

class RemoteParticipantOptions extends StatefulWidget {
  final Participant participant;

  const RemoteParticipantOptions({Key? key, required this.participant})
      : super(key: key);

  @override
  State<RemoteParticipantOptions> createState() =>
      _RemoteParticipantOptionsState();
}

class _RemoteParticipantOptionsState extends State<RemoteParticipantOptions> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  List<ConferencePermission> permissionsList = [];
  bool isRemoteMuted = false;

  void updatePermissionsList(List<ConferencePermission> newPermissionsList) {
    setState(() {
      permissionsList = newPermissionsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
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
                  leading: Icon(Icons.remove, color: Colors.deepPurple)),
            ),
            PopupMenuItem<int>(
              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
              value: 1,
              child: isRemoteMuted
                  ? const ListTile(
                      leading: Icon(Icons.mic_off, color: Colors.deepPurple),
                      title: Text('Unmute'))
                  : const ListTile(
                      leading: Icon(Icons.mic, color: Colors.deepPurple),
                      title: Text('Mute')),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 2,
              child: ListTile(
                title: Text('Update permissions'),
                leading: Icon(Icons.perm_camera_mic_outlined,
                    color: Colors.deepPurple),
              ),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 3,
              child: ListTile(
                  title: Text('Set spatial position'),
                  leading: Icon(Icons.spatial_audio, color: Colors.deepPurple)),
            )
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              kickParticipant();
              break;
            case 1:
              muteRemoteParticipant();
              break;
            case 2:
              showPermissionsDialog();
              break;
            case 3:
              showSpatialPositionDialog(context);
              break;
          }
        });
  }

  Future<void> kickParticipant() async {
    final participant = await _upToDateParticipant();
    _dolbyioCommsSdkFlutterPlugin.conference.kick(participant);
  }

  Future<void> muteRemoteParticipant() async {
    final participant = await _upToDateParticipant();
    if (isRemoteMuted == false) {
      _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, true);
      setState(() => isRemoteMuted = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, false);
      setState(() => isRemoteMuted = false);
    }
  }

  Future<void> updatePermissions() async {
    try {
      final participant = await _upToDateParticipant();
      await _dolbyioCommsSdkFlutterPlugin.conference.updatePermissions(
          [ParticipantPermissions(participant, permissionsList)]);
      await showDialogWindow('Success', "OK");
    } catch (error) {
      showDialogWindow('Error',
          "$error\nThis method is only available  for protected conferences");
    }
  }

  Future<void> showDialogWindow(String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  Future<Participant> _upToDateParticipant() async {
    return _dolbyioCommsSdkFlutterPlugin.conference
        .getParticipant(widget.participant.id);
  }

  Future<void> showPermissionsDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update permissions"),
            actionsOverflowButtonSpacing: 20,
            content:
                PermissionsList(permissionsCallback: updatePermissionsList),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    updatePermissions();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Update")),
              ElevatedButton(
                  onPressed: () {
                    permissionsList.clear();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  Future<void> showSpatialPositionDialog(BuildContext context) async {
    final participant = await _upToDateParticipant();
    return showDialog(
        context: context,
        builder: (BuildContext spatialPositionContext) {
          return AlertDialog(
            title: const Text("Spatial position"),
            content: SpatialPosiotionDialogContent(
                participant: participant,
                spatialPositiontDialogContext: spatialPositionContext,
                resultDialogContext: context),
          );
        });
  }
}
