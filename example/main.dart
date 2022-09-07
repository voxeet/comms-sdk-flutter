// Step 1. Create a new project and replace the contents of it's main.dart file with this example

// Step 2: Import the permission handler package
import 'package:permission_handler/permission_handler.dart';
// Step 3: Import the Dolby.io Communications SDK for Flutter
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
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
 
    // Step 7: Call updateParticipantsList()
    updateParticipantsList();
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
                          decoration: const InputDecoration(hintText: 'Conference name'),
                          controller: conferenceNameController,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            // Step 5: Call joinConference()
                            await joinConference();
                          },
                          child: isJoining
                            ? const Text('Joining...')
                            : const Text('Join the conference'),
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

                        // Step 7: Display the list of participants
                        Material(
                          elevation: 8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: participants.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text("${participants[index].info!.name} (${participants[index].status?.name})"),
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
                          onPressed: () async {
                            // Step 6: Call leaveConference()
                            await leaveConference();
                          },
                          child: isJoining
                            ? const Text('Leaving...')
                            : const Text('Leave the conference'),
                        )
                      ])
                    : const Center(child: Text("Join the conference to see the list of participants.")))
          ],
        ),
      ),
    );
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
    var createOptions = ConferenceCreateOption(conferenceNameController.text, params, 0);

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
    
    setState(() => isInitializedList = true);
    setState(() => isLeaving = true);
  }

  // Step 7: Define the updateParticipantsList method
  void updateParticipantsList() {
    dolbyioCommsSdk.conference.onParticipantsChange()
      .listen((params) async {
        try {
          var conference = await dolbyioCommsSdk.conference.current();
          var participantsList = await dolbyioCommsSdk.conference.getParticipants(conference);
          
          setState(() => participants = participantsList);
          setState(() => isInitializedList = true);
        } catch (error) {
          developer.log("Error during initializing participant list.", error: error);
        }
      });
  }
}
