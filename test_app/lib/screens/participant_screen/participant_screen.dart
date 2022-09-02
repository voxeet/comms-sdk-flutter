import '../test_buttons/test_buttons.dart';
import 'conference_controls.dart';
import 'conference_title.dart';
import '/screens/test_buttons/test_buttons.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'participant_grid.dart';
import '/widgets/modal_bottom_sheet.dart';
import '/widgets/dolby_title.dart';
import 'dart:developer' as developer;

class ParticipantScreen extends StatefulWidget {
  final bool switchValue;
  const ParticipantScreen({Key? key, required this.switchValue}) : super(key: key);

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
              children:   [
                const DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
                ParticipantScreenContent(switchValue: widget.switchValue)
              ]
          ),
        ),
      ),
    );
  }
}

class ParticipantScreenContent extends StatefulWidget {
  final bool switchValue;
  const ParticipantScreenContent({Key? key, required this.switchValue}) : super(key: key);

  @override
  State<ParticipantScreenContent> createState() => _ParticipantScreenContentState();
}

class _ParticipantScreenContentState extends State<ParticipantScreenContent> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>? onStatusChangeSubscription;

  @override
  void initState() {
    super.initState();
    checkSwitchValue();
  }

  @override
  void dispose() {
    super.dispose();
    onStatusChangeSubscription?.cancel();
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
              const ParticipantGrid(),
              const ModalBottomSheet(child: TestButtons()),
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

  void checkSwitchValue() {
    if(widget.switchValue == true) {
      onStatusChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
          .onStatusChange()
          .listen((params) {
        StatusSnackbar.buildSnackbar(context, params.body.name.toString());;
      });
    } else {
      onStatusChangeSubscription?.cancel();
    }
  }
}
