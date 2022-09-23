import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/dolby_title.dart';
import 'participant_screen/participant_grid.dart';

class ReplayScreen extends StatefulWidget {
  final Conference conference;
  const ReplayScreen({Key? key, required this.conference}) : super(key: key);

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
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
              children: [
                const DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
                ParticipantScreenContent(conference: widget.conference)
              ]
          ),
        ),
      ),
    );
  }
}

class ParticipantScreenContent extends StatefulWidget {
  final Conference conference;
  const ParticipantScreenContent({Key? key, required this.conference}) : super(key: key);

  @override
  State<ParticipantScreenContent> createState() => _ParticipantScreenContentState();
}

class _ParticipantScreenContentState extends State<ParticipantScreenContent> {

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>? conferenceStatusChangeSubscription;
  List<Participant> participants = [];

  @override
  void initState() {
    super.initState();
    conferenceStatusChangeSubscription =
        _dolbyioCommsSdkFlutterPlugin.conference.onStatusChange().listen((event) {
          if(event.body.encode() == ConferenceStatus.ended.encode()) {
            Navigator.of(context).popUntil(ModalRoute.withName("JoinConferenceScreen"));
          }
        });
  }

  @override
  void deactivate() {
    conferenceStatusChangeSubscription?.cancel();
    super.deactivate();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                  child: Text(
                      widget.conference.id!,
                      style: const TextStyle(fontSize: 16)),
              ),
            ),
            Expanded(
              child: Stack(
                children: const [
                  ParticipantGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
