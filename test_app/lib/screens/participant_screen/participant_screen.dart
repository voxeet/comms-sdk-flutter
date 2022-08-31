import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/modal_bottom_sheet.dart';
import 'participant_grid.dart';
import '/widgets/dolby_title.dart';
import 'conference_controls.dart';
import 'conference_title.dart';

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
              ParticipantGrid(),
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
}
