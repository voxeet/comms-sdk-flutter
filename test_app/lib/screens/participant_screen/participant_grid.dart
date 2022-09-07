import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/dialogs.dart';
import 'participant_widget.dart';
import 'dart:developer' as developer;

class ParticipantGrid extends StatefulWidget {
  const ParticipantGrid({Key? key}) : super(key: key);

  @override
  State<ParticipantGrid> createState() => _ParticipantGridState();
}

class _ParticipantGridState extends State<ParticipantGrid> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  List<Participant> participants = [];

  StreamSubscription<Event<ConferenceServiceEventNames, Participant>>? onParticipantsChangeSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, StreamsChangeData>>? onStreamsChangeSubscription;
  StreamSubscription<Event<CommandServiceEventNames, MessageReceivedData>>? onMessageReceivedChangeSubscription;

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

    onParticipantsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
      .onParticipantsChange()
      .listen((params) {
        initParticipantsList();
        developer.log("onParticipantsChange");
      });

    onStreamsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
      .onStreamsChange()
      .listen((params) {
        initParticipantsList();
        developer.log("onStreamsChange");
      });

    onMessageReceivedChangeSubscription = _dolbyioCommsSdkFlutterPlugin.command
      .onMessageReceived()
      .listen((params) {
        showDialog(context, params.type.name, "Message: ${params.body.message}");
        developer.log("onMessageReceived");
      });
  }

  @override
  void dispose() {
    onParticipantsChangeSubscription?.cancel();
    onStreamsChangeSubscription?.cancel();
    onMessageReceivedChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                participantIndex: index
            );
          }),
    );
  }

  Future<void> initParticipantsList() async {
    final currentConference = await _dolbyioCommsSdkFlutterPlugin.conference.current();
    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin.conference.getParticipants(currentConference);
    final availableParticipants = conferenceParticipants.where((element) => element.status != ParticipantStatus.left);
    setState(() => participants = availableParticipants.toList());
    return Future.value();
  }
}
