// Step 1. Create a new project and replace the contents of it's main.dart file with this example

// Step 2: Import the permission handler package
import 'package:permission_handler/permission_handler.dart';
// Step 3: Import the Dolby.io Communications SDK for Flutter
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'dart:math';
import 'dart:core';
import 'dart:developer' as developer;

void main() {
  runApp(const MaterialApp(home: FlutterScreen()));
}

class FlutterScreen extends StatefulWidget {
  const FlutterScreen({Key? key}) : super(key: key);

  @override
  State<FlutterScreen> createState() => _FlutterScreenState();
}

class _FlutterScreenState extends State<FlutterScreen> {
  // Step 3: Instantiate the SDK here
  final dolbyioCommsSdk = DolbyioCommsSdk.instance;

  TextEditingController usernameController = TextEditingController();
  TextEditingController conferenceNameController = TextEditingController();

  // Generate a client access token from the Dolby.io dashboard
  // and insert the token to the accessToken variable
  String accessToken = '';

  bool isLeaving = false;
  bool isJoining = false;
  bool isInitializedList = false;

  // Step 7: Store the participants list here
  List<Participant> participants = [];

  // Step 7: Define StreamSubscriptions here
  StreamSubscription<Event<ConferenceServiceEventNames, Participant>>?
      onParticipantsChangeSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, StreamsChangeData>>?
      onStreamsChangeSubscription;

  @override
  void initState() {
    super.initState();

    // Step 2: Request the microphone and camera permissions
    [
      Permission.bluetoothConnect,
      Permission.microphone,
      Permission.camera,
    ].request();

    // Step 3: Call initializeSdk()
    initializeSdk();

    // Step 4: Call openSession()
    openSession();

    // Step 7: Call updateParticipantsList() with StreamSubscriptions
    onParticipantsChangeSubscription =
        dolbyioCommsSdk.conference.onParticipantsChange().listen((params) {
      updateParticipantsList();
    });

    onStreamsChangeSubscription =
        dolbyioCommsSdk.conference.onStreamsChange().listen((params) {
      updateParticipantsList();
    });
  }

  // Step 7: Cancel StreamSubscriptions
  @override
  void dispose() {
    onParticipantsChangeSubscription?.cancel();
    onStreamsChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Flutter SDK'), centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: !isInitializedList
                ? Column(
                    children: [
                      TextField(controller: usernameController, readOnly: true),
                      const SizedBox(height: 12),
                      TextField(
                          decoration: const InputDecoration(
                              hintText: 'Conference name'),
                          controller: conferenceNameController),
                      const SizedBox(height: 12),
                      ElevatedButton(
                          onPressed: () async {
                            // Step 5: Call joinConference()
                            await joinConference();
                          },
                          child: isJoining
                              ? const Text('Joining...')
                              : const Text('Join the conference')),
                      const Divider(thickness: 2),
                      const Text(
                          "Join the conference to see the list of participants.")
                    ],
                  )
                : Column(children: [
                    Text('Conference name: ${conferenceNameController.text}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Column(children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('List of participants:',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600))),
                        const SizedBox(height: 16),

                        // Step 7: Display the list of participants
                        Expanded(
                          child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 5);
                              },
                              shrinkWrap: true,
                              itemCount: participants.length,
                              itemBuilder: (context, index) {
                                var participant = participants[index];
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(children: [
                                    Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                            height: 150,
                                            width: 150,
                                            child: VideoView.withMediaStream(
                                                participant: participant,
                                                mediaStream: participant.streams
                                                    ?.firstWhereOrNull((s) =>
                                                        s.type ==
                                                        MediaStreamType.camera),
                                                key: ValueKey(
                                                    'video_view_tile_${participant.id}')))),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${participant.info?.name.toString()}"),
                                            Text(
                                                "status: ${participant.status?.name}")
                                          ]),
                                    ),
                                  ]),
                                );
                              }),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () async {
                          // Step 6: Call leaveConference()
                          await leaveConference();
                        },
                        child: isJoining
                            ? const Text('Leaving...')
                            : const Text('Leave the conference'))
                  ])));
  }

  // Step 3: Define the initializeSdk function
  Future<void> initializeSdk() async {
    // Initialize the SDK with the access token
    await dolbyioCommsSdk.initializeToken(accessToken, () async {
      // Request a new access token here
      return accessToken;
    });
  }

  // Step 4: Define the openSession function
  Future<void> openSession() async {
    // Generate a random username
    int randomNumber = Random().nextInt(1000);
    usernameController.text = "user-$randomNumber";

    // Open a new session for the local participant
    var participantInfo = ParticipantInfo(usernameController.text, null, null);
    await dolbyioCommsSdk.session.open(participantInfo);
  }

  // Step 5: Define the joinConference function
  Future<void> joinConference() async {
    setState(() => isJoining = true);

    // Create conference options
    var params = ConferenceCreateParameters();
    params.dolbyVoice = true;
    var createOptions =
        ConferenceCreateOption(conferenceNameController.text, params, 0);

    // Join the conference with audio and video
    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);

    // Join the conference
    var conference = await dolbyioCommsSdk.conference.create(createOptions);
    conference = await dolbyioCommsSdk.conference.join(conference, joinOptions);

    // Check the conference status
    if (conference.status == ConferenceStatus.joined) {
      setState(() => isJoining = false);
      developer.log('Joined to conference.');
    } else {
      developer.log('Cannot join to conference.');
    }
  }

  // Step 6: Define the leaveConference function
  Future<void> leaveConference() async {
    setState(() => isLeaving = true);

    await dolbyioCommsSdk.conference.leave(options: null);

    setState(() => isInitializedList = false);
    setState(() => isLeaving = false);
  }

  // Step 7: Define the updateParticipantsList method
  Future<void> updateParticipantsList() async {
    try {
      var conference = await dolbyioCommsSdk.conference.current();
      var participantsList =
          await dolbyioCommsSdk.conference.getParticipants(conference);
      final availableParticipants = participantsList
          .where((element) => element.status != ParticipantStatus.left);

      setState(() {
        participants = availableParticipants.toList();
        isInitializedList = true;
      });
    } catch (error) {
      developer.log("Error during initializing participant list.",
          error: error);
    }
  }
}
