// 1. Import SDK
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

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
  // 2. Import sdk flutter plugin
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  TextEditingController usernameController = TextEditingController();
  TextEditingController conferenceNameController = TextEditingController();

  String accessToken = '';

  bool isLeaving = false;
  bool isJoining = false;
  bool isInitializedList = false;

  // 9. List for storing participants
  List<Participant> participants = [];

  @override
  void initState() {
    super.initState();

    [
      Permission.bluetoothConnect,
      Permission.microphone,
      Permission.camera,
    ].request();

    // 4. Initialize SDK
    initializeSdk();

    // 6. Open session
    openSession();

    // 11. Update participants list after any change
    _dolbyioCommsSdkFlutterPlugin.conference
        .onParticipantsChange()
        .listen((params) {
      _dolbyioCommsSdkFlutterPlugin.conference.current().then((conference) =>
          _dolbyioCommsSdkFlutterPlugin.conference
              .getParticipants(conference)
              .then((participantsList) {
            setState(() => participants = participantsList);
            setState(() => isInitializedList = true);
          }).onError((error, stackTrace) {
            developer.log("Error during initializing participant list.",
                error: error);
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SDK'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isInitializedList) ...[
              Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: usernameController,
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: const InputDecoration(
                              hintText: 'Conference name'),
                          controller: conferenceNameController,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            joinConference();
                          },
                          child: isJoining
                              ? const Text('Joining...')
                              : const Text('Join to conference'),
                        ),
                      ],
                    ),
                  )),
              const Divider(
                thickness: 2,
              ),
            ],
            Expanded(
                flex: 5,
                child: isInitializedList
                    ? Column(children: [
                        Text(
                          'Conference name: ${conferenceNameController.text}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'List of participants:',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            )),
                        const SizedBox(
                          height: 16,
                        ),
                        // 10. UI for participants
                        Material(
                          elevation: 8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: participants.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    "${participants[index].info!.name} (${participants[index].status?.name})"),
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            leave();
                          },
                          child: isLeaving
                              ? const Text('Leaving...')
                              : const Text("Leave conference"),
                        )
                      ])
                    : const Center(
                        child: Text(
                            "Join to conference to see participants list.")))
          ],
        ),
      ),
    );
  }

  // 3. Define initialize SDK method
  Future<void> initializeSdk() async {
    // Generate a client access token from the Dolby.io dashboard and insert into access_token variable;
    accessToken = '';

    // Initialize sdk with access token from dolby.io dashboard
    // In final solution please make sure refresh token is properly implemented
    await _dolbyioCommsSdkFlutterPlugin.initializeToken(accessToken, () async {
      return /* refresh token */ accessToken;
    });
  }

  // 5. Define open session method
  void openSession() {
    // Generate random user name
    int randomNumber = Random().nextInt(1000);
    usernameController.text = "user-$randomNumber";

    // Open session for participant
    var participantInfo = ParticipantInfo(usernameController.text, null, null);
    _dolbyioCommsSdkFlutterPlugin.session.open(participantInfo);
  }

  // 7. Create conference and/or join to it
  void joinConference() {
    setState(() => isJoining = true);

    // Create conference options
    var params = ConferenceCreateParameters();
    params.dolbyVoice = true;
    var createOptions =
        ConferenceCreateOption(conferenceNameController.text, params, 0);

    // Join conference with audio and video
    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);

    // Join to conference
    _dolbyioCommsSdkFlutterPlugin.conference
        .create(createOptions)
        .then((value) =>
            _dolbyioCommsSdkFlutterPlugin.conference.join(value, joinOptions))
        .then((conference) {
      // Check conference status
      if (conference.status == ConferenceStatus.joined) {
        _dolbyioCommsSdkFlutterPlugin.conference.current().then((value) {
          setState(() => isJoining = false);
        });
        developer.log('Joined to conference.');
      } else {
        developer.log('Cannot join to conference.');
      }
    });
  }

  // 8. Leave conference
  void leave() {
    setState(() => isLeaving = true);

    // Leave conference
    _dolbyioCommsSdkFlutterPlugin.conference
        .current()
        .then((value) => _dolbyioCommsSdkFlutterPlugin.conference.leave(null))
        .then((value) => setState(() => isInitializedList = false))
        .then((value) => setState(() => isLeaving = false));
  }
}
