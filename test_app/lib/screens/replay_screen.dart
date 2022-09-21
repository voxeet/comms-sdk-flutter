import 'package:dolbyio_comms_sdk_flutter_example/screens/participant_screen/conference_controls.dart';

import 'participant_screen/conference_title.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/dolby_title.dart';
import 'dart:developer' as developer;

import 'participant_screen/participant_widget.dart';

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
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>? _conferenceStatusChangeSubscription;
  //StreamSubscription<Event<ConferenceServiceEventNames, StreamsChangeData>>? onStreamsChangeSubscription;
  List<Participant> participants = [];

  @override
  void initState() {
    super.initState();

    initParticipantsList();
    developer.log("Replayed Conference: " + widget.conference.toJson().toString());

    // onParticipantsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
    //     .onParticipantsChange()
    //     .listen((params) {
    //   initParticipantsList();
    //   developer.log("onParticipantsChange");
    // });

    // onStreamsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
    //     .onStreamsChange()
    //     .listen((params) {
    //   initParticipantsList();
    //   developer.log("onStreamsChange");
    // });
    _conferenceStatusChangeSubscription =
        _dolbyioCommsSdkFlutterPlugin.conference.onStatusChange().listen((event) {
          if(event.body.encode() == ConferenceStatus.ended.encode()) {
            Navigator.of(context).popUntil(ModalRoute.withName("JoinConferenceScreen"));
          }
        });

  }

  @override
  void deactivate() {
    //onParticipantsChangeSubscription?.cancel();
    //onStreamsChangeSubscription?.cancel();
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
            ConferenceTitle(conference: getCurrentConference()),
            Expanded(
                child: Stack(
                    children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                          itemCount: participants.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12
                          ),
                          itemBuilder: (context, index) {
                            var participant = participants[index];
                            return ParticipantWidget(
                                participant: participant,
                                isLocal: index == 0
                            );
                          }),
                    )
                    ]
                )
            ),
          //  ConferenceControls(conference: getCurrentConference())
          ],
        ),
      ),
    );
  }

  Future<void> initParticipantsList() async {
    final currentConference = await _dolbyioCommsSdkFlutterPlugin.conference.fetch(widget.conference.id);
    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(currentConference);
    final availableParticipants = conferenceParticipants;
    // .where((element) => element.status != ParticipantStatus.left);
    setState(() => participants = availableParticipants.toList());
    return Future.value();
  }

  Future<Conference?> getCurrentConference() async {
    Conference? conference;
    await _dolbyioCommsSdkFlutterPlugin.conference
        .fetch(widget.conference.id)
        .then((value) {conference = value;});
    return conference;
  }
}
