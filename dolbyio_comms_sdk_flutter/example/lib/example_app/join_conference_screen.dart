import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/example_app/participant_screen_video.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/primary_button.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/conference.dart';
import 'dart:developer' as developer;

class JoinConferenceScreen extends StatefulWidget {
  @override
  _JoinConferenceScreenState createState() => _JoinConferenceScreenState();
}

class _JoinConferenceScreenState extends State<JoinConferenceScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController conferenceNameTextController = TextEditingController();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Join Conference'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextFormField(labelText: 'Conference name', controller: conferenceNameTextController,),
                const SizedBox(
                  height: 32,
                ),
                PrimaryButton(
                    widgetText: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text('Joining...')
                            ],
                          )
                        : const Text('Join'),
                    onPressed: () {
                      onJoinButtonPressed();
                    }),
              ],
            ),
          ),
        ),
      );

  void onJoinButtonPressed() {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      setState(() => isLoading = true);
      joinConference();
      } else {
      developer.log("Cannot join conference due to error.");
    }
  }

  void joinConference() {
    createConference()
        .then((value) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .join(value, conferenceJoinOptions())
            .then((value) => checkJoinConferenceResult(value))
            .onError((error, stackTrace) => onJoinConferenceError(error)))
        .onError((error, stackTrace) => onCreateConferenceError(error));
  }

  Future<Conference> createConference() {
    var conference = _dolbyioCommsSdkFlutterPlugin.conference
        .create(conferenceCreateOptions());
    return conference;
  }

  ConferenceCreateOption conferenceCreateOptions() {
    var conferenceName = conferenceNameTextController.text;
    var params = ConferenceCreateParameters();
    params.dolbyVoice = true;
    var createOptions = ConferenceCreateOption(conferenceName, params, 0);
    return createOptions;
  }

  ConferenceJoinOptions conferenceJoinOptions() {
    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);
    joinOptions.maxVideoForwarding = 4;
    joinOptions.spatialAudio = true;
    return joinOptions;
  }

  void checkJoinConferenceResult(Conference conference) {
    if (conference.status == ConferenceStatus.JOINED) {
      _dolbyioCommsSdkFlutterPlugin.conference.current().then((value) {
        developer.log("Create conference with name: ${value.alias.toString()}");
      });
      navigateToParticipantScreen();
      developer.log("Joined to conference.");
    } else {
      developer.log("Cannot join to conference.");
    }
  }

  void onCreateConferenceError(Object? error) {
    developer.log("Error during creating conference.", error: error);
  }

  void onJoinConferenceError(Object? error) {
    developer.log("Error during joining to conference.", error: error);
  }

  void navigateToParticipantScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ParticipantScreenVideo()));
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => isLoading = false);
    });
  }
}
