import 'package:dolbyio_comms_sdk_flutter_example/state_management/models/conference_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '/widgets/bottom_tool_bar.dart';
import '/widgets/conference_action_icon_button.dart';
import '/widgets/dolby_title.dart';
import 'participant_screen/participant_grid.dart';

class ReplayScreen extends StatefulWidget {
  const ReplayScreen({Key? key}) : super(key: key);

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
            children: const [
              DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
              ReplayScreenContent()
            ],
          ),
        ),
      ),
    );
  }
}

class ReplayScreenContent extends StatefulWidget {
  const ReplayScreenContent({Key? key}) : super(key: key);

  @override
  State<ReplayScreenContent> createState() => _ReplayScreenContentState();
}

class _ReplayScreenContentState extends State<ReplayScreenContent> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>?
      conferenceStatusChangeSubscription;
  List<Participant> participants = [];

  @override
  void initState() {
    super.initState();
    conferenceStatusChangeSubscription = _dolbyioCommsSdkFlutterPlugin
        .conference
        .onStatusChange()
        .listen((event) {
      if (event.body.encode() == ConferenceStatus.ended.encode()) {
        Provider.of<ConferenceModel>(context, listen: false)
            .isReplayConference = false;
        Navigator.of(context)
            .popUntil(ModalRoute.withName("JoinConferenceScreen"));
      }
    });
  }

  @override
  void deactivate() {
    conferenceStatusChangeSubscription?.cancel();
    var options = ConferenceLeaveOptions(false);
    _dolbyioCommsSdkFlutterPlugin.conference.leave(options: options);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var conference =
        Provider.of<ConferenceModel>(context, listen: false).replayedConference;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(conference.id ?? "Invalid alias",
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
            const Expanded(child: ParticipantGrid()),
            const ReplayControllsWidget(),
          ],
        ),
      ),
    );
  }
}

class ReplayControllsWidget extends StatelessWidget {
  const ReplayControllsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomToolBar(children: [
      ConferenceActionIconButton(
          onPressedIcon: () => Navigator.of(context).pop(),
          iconWidget: const Icon(Icons.phone),
          backgroundIconColor: Colors.red)
    ]);
  }
}
