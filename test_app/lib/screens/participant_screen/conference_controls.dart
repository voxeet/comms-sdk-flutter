import 'package:dolbyio_comms_sdk_flutter_example/conference_ext.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/bottom_tool_bar.dart';
import 'package:file_picker/file_picker.dart';
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
  bool isMicOff = false;
  bool isVideoOff = false;
  bool isScreenShareOff = true;
  FileConverted? _fileConverted;

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
      PopupMenuButton(
        position: PopupMenuPosition.under,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.ios_share_rounded, color: Colors.white),
          ),
        ),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: isScreenShareOff
                  ? const Text('Share screen')
                  : const Text('Stop sharing'),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text('Share file'),
            ),
          ];
        },
        onSelected: (value) async {
          switch (value) {
            case 0:
              if (isScreenShareOff) {
                startScreenShare();
              } else {
                stopScreenShare();
              }
              break;
            case 1:
              await convertFile();
              if (_fileConverted != null) {
                startFilePresentation();
              }
              break;
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

  Future<void> convertFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'ppt', 'pptx', 'pdf'],
      );
      String? path = result?.files.single.path;

      if (path == null) {
        if (!mounted) return;
        showResultDialog(context, 'File not selected', '');
        return;
      }

      var fileConverted = await _dolbyioCommsSdkFlutterPlugin.filePresentation
          .convert(File(path));
      _fileConverted = fileConverted;
      if (!mounted) return;
      showResultDialog(context, 'Success', 'File converted.');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error: ', error.toString());
    }
  }

  Future<void> startFilePresentation() async {
    try {
      if (_fileConverted == null) {
        if (!mounted) return;
        showResultDialog(context, 'You must convert file first!', '');
        return;
      }

      await _dolbyioCommsSdkFlutterPlugin.filePresentation
          .start(_fileConverted!);
      if (!mounted) return;
      showResultDialog(
          context, 'Success', 'File presentation has been started.');
    } catch (error) {
      if (!mounted) return;
      showResultDialog(context, 'Error: ', error.toString());
    }
  }

  Future<bool> isSomeoneScreenSharing() async {
    final conference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
    if (conference == null) {
      throw Exception(
          "_ConferenceControlsState.isSomeoneScreenSharing(): Could not find a current conference");
    }
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
