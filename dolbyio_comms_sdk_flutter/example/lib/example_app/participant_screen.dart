import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/modal_bottom_sheet.dart';
import '/widgets/participant_grid.dart';
import '/widgets/dialogs.dart';
import '/widgets/dolby_title.dart';
import '/widgets/conference_controls.dart';
import '/widgets/conference_title.dart';

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({Key? key}) : super(key: key);

  @override
  State<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(color: Colors.deepPurple),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  const [
                DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
                ParticipantScreenContent()
              ]
          ),
        ),
      ),
    );
  }
}

class ParticipantScreenContent extends StatefulWidget {
  const ParticipantScreenContent({Key? key}) : super(key: key);

  @override
  State<ParticipantScreenContent> createState() => _ParticipantScreenContentState();
}

class _ParticipantScreenContentState extends State<ParticipantScreenContent> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  List<Participant> participants = [];

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  @override
  void initState() {
    super.initState();
    initParticipantsList();

    _dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange().listen((params) {
      initParticipantsList();
      developer.log("onParticipantsChange");
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
    return Expanded(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))
          ),
          child: Column(
            children: [
              ConferenceTitle(conference: getCurrentConference()),
              ParticipantGrid(participants: participants),
              const ShowModalBottomSheet(),
              ConferenceControls(conference: getCurrentConference()),
            ],
          ),
        ),
      );
  }

  Future<Conference?> getCurrentConference() async {
    Conference? conference;
    await _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) {conference = value;});
    return conference;
  }

  Future<void> initParticipantsList() async {
    final currentConference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(currentConference);
    final availableParticipants = conferenceParticipants.where((element) => element.status != ParticipantStatus.LEFT);
    setState(() => participants = availableParticipants.toList());
    return Future.value();
  }
}

void onError(String message, Object? error) {
  developer.log(message, error: error);
}
