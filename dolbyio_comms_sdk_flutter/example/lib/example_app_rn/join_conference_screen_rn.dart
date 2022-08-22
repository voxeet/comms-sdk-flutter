import 'package:dolbyio_comms_sdk_flutter_example/widgets/circular_progress_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'participant_screen_rn.dart';
import '../widgets/text_form_field.dart';
import '../widgets/two_color_text.dart';
import '../widgets/dolby_title.dart';
import '../widgets/primary_button.dart';
import '../widgets/dialogs.dart';
import '../permission_helper.dart';

class JoinConferenceRN extends StatelessWidget {
  final String username;

  const JoinConferenceRN({Key? key, required this.username}) : super(key: key);

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
                  JoinConferenceContent(username: username)
                ],
              )
          )
      ),
    );
  }
}

class JoinConferenceContent extends StatefulWidget {
  final String username;

  JoinConferenceContent({Key? key, required this.username}) : super(key: key);

  @override
  State<JoinConferenceContent> createState() => _JoinConferenceContentState();
}

class _JoinConferenceContentState extends State<JoinConferenceContent> {
  final TextEditingController conferenceAliasTextController = TextEditingController();
  final TextEditingController conferenceIdTextController = TextEditingController();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  final formKey = GlobalKey<FormState>();
  bool isJoining = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TwoColorText(
                blackText: "Logged in as ",
                colorText: widget.username
              ),
              const SizedBox(height: 16),
              Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: InputTextFormField(
                  labelText: 'Conference alias',
                  controller: conferenceAliasTextController,
                  focusColor: Colors.deepPurple
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                  widgetText: isJoining
                    ? const WhiteCircularProgressIndicator()
                    : const Text('Join'),
                  onPressed: () { 
                     if (defaultTargetPlatform == TargetPlatform.android) {
                      checkPermissions();
                      return;
                     }
                     onJoinButtonPressed();
                  },
                  color: Colors.deepPurple
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkPermissions() {
    Permissions.checkPermissions(
      permissions: [Permission.camera, Permission.microphone],
      onGranted: () => onJoinButtonPressed(),
      onPermanentlyDenied: (permissions) async {
        await ViewDialogs.dialog(
          context: context,
          title: 'Permissions missing',
          body: 'Required permissions $permissions were denied. Please enable them manually.',
          okText: 'Open settings',
          cancelText: 'Cancel',
          result: (value) => value ? openAppSettings() : null,
        );
      },
      onDenied: (permissions) {
        Fluttertoast.showToast(msg: "Permissions $permissions missing, can't continue");
      },
    );    
  }

  void onJoinButtonPressed() {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      setState(() => isJoining = true);
      join();
    } else {
      developer.log('Cannot join to conference due to error.');
    }
  }

  void join() {
    create().then((value) {
      _dolbyioCommsSdkFlutterPlugin.conference.join(value, conferenceJoinOptions())
          .then((value) => checkJoinConferenceResult(value))
          .onError((error, stackTrace) => onError('Error during joining conference.', error));
    });
  }

  Future<Conference> create() {
    var conference = _dolbyioCommsSdkFlutterPlugin.conference.create(conferenceCreateOptions());
    return conference;
  }

  ConferenceCreateOption conferenceCreateOptions() {
    var conferenceName = conferenceAliasTextController.text;
    var params = ConferenceCreateParameters();
    params.dolbyVoice = true;
    var createOptions = ConferenceCreateOption(conferenceName, params, 0);
    return createOptions;
  }

  ConferenceJoinOptions conferenceJoinOptions() {
    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);
    joinOptions.maxVideoForwarding = 4;
    joinOptions.spatialAudio = false;
    return joinOptions;
  }

  void checkJoinConferenceResult(Conference conference) {
    if (conference.status == ConferenceStatus.JOINED) {
      navigateToParticipantScreen(context);
    } else {
      developer.log('Cannot join to conference.');
    }
  }

  Future navigateToParticipantScreen(BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ParticipantScreenRN())
    );
    setState(() => isJoining = false);
  }
}
