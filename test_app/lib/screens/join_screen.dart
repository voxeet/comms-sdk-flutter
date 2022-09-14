import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/status_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '/widgets/text_form_field.dart';
import '/widgets/two_color_text.dart';
import '/widgets/dolby_title.dart';
import '/widgets/primary_button.dart';
import '/widgets/dialogs.dart';
import '/widgets/circular_progress_indicator.dart';
import '/permission_helper.dart';
import 'participant_screen/participant_screen.dart';
import 'dart:developer' as developer;

class JoinConference extends StatelessWidget {
  final String username;
  final String externalId;

  const JoinConference({Key? key, required this.username, required this.externalId}) : super(key: key);

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
                  JoinConferenceContent(username: username, externalId: externalId)
                ],
              )
          )
      ),
    );
  }
}

class JoinConferenceContent extends StatefulWidget {
  final String username;
  final String externalId;

  const JoinConferenceContent({Key? key, required this.username, required this.externalId}) : super(key: key);

  @override
  State<JoinConferenceContent> createState() => _JoinConferenceContentState();
}

class _JoinConferenceContentState extends State<JoinConferenceContent> {
  final TextEditingController conferenceAliasTextController = TextEditingController();
  final TextEditingController conferenceIdTextController = TextEditingController();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  final formKey = GlobalKey<FormState>();
  bool isJoining = false;
  bool switchConferenceStatus = false;
  bool switchSpatialAudio = false;
  bool switchDolbyVoice = false;
  StreamSubscription<Event<NotificationServiceEventNames, InvitationReceivedNotificationData>>? onInvitationReceivedSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>? onStatusChangeSubscription;

  @override
  void initState() {
    super.initState();

    onInvitationReceivedSubscription = _dolbyioCommsSdkFlutterPlugin.notification
        .onInvitationReceived()
        .listen((params) {
          showInvitationDialog(
              context, params.body.toJson().toString(),
              params.body.conferenceId.toString());
        });
  }

  @override
  void dispose() {
    onInvitationReceivedSubscription?.cancel();
    onStatusChangeSubscription?.cancel();
    super.dispose();
  }

  Future<void> showInvitationDialog(BuildContext context, String body, String conferenceId) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invitation received"),
            actionsOverflowButtonSpacing: 20,
            content: Text(body),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    joinInvitation(conferenceId);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Join")
              ),
              ElevatedButton(
                  onPressed: () {
                    declineInvitation(conferenceId);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Decline")
              ),
            ],
          );
        }
    );
  }

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
              TwoColorText(
                  blackText: "External ID  ",
                  colorText: widget.externalId
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
              Row(
                children: [
                  const Text("Observe Conference Status"),
                  CupertinoSwitch(
                      value: switchConferenceStatus,
                      onChanged: (value) {
                        setState(() {
                          switchConferenceStatus = value;
                          observeConferenceStatus(switchConferenceStatus);
                        });
                      }
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Spatial Audio"),
                  CupertinoSwitch(
                      value: switchSpatialAudio,
                      onChanged: (value) {
                        setState(() {
                          switchSpatialAudio = value;
                        });
                      }
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Dolby Voice"),
                  CupertinoSwitch(
                      value: switchDolbyVoice,
                      onChanged: (value) {
                        setState(() {
                          switchDolbyVoice = value;
                        });
                      }
                  ),
                ],
              ),
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
      permissions: [Permission.camera, Permission.microphone, Permission.bluetoothConnect],
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
    params.dolbyVoice = switchDolbyVoice;
    var createOptions = ConferenceCreateOption(conferenceName, params, 0);
    return createOptions;
  }

  ConferenceJoinOptions conferenceJoinOptions() {
    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);
    joinOptions.maxVideoForwarding = 4;
    joinOptions.spatialAudio = switchSpatialAudio;
    return joinOptions;
  }

  void checkJoinConferenceResult(Conference conference) {
    if (conference.status == ConferenceStatus.joined) {
      navigateToParticipantScreen(context);
    } else {
      developer.log('Cannot join to conference.');
    }
  }

  void joinInvitation(String conferenceId) {
    _dolbyioCommsSdkFlutterPlugin.conference.fetch(conferenceId).then((value) => {
      _dolbyioCommsSdkFlutterPlugin.conference.join(value, conferenceJoinOptions())
          .then((value) => checkJoinConferenceResult(value))
          .onError((error, stackTrace) => onError('Error during joining conference.', error))
    });
  }
  
  void declineInvitation(String conferenceId) {
    _dolbyioCommsSdkFlutterPlugin.conference.fetch(conferenceId)
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.notification.decline(conference))
        .onError((error, stackTrace) => onError('Error during declining.', error));
  }

  void observeConferenceStatus(bool switchValue) {
    if(switchValue == true) {
      onStatusChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
          .onStatusChange()
          .listen((params) {
        StatusSnackbar.buildSnackbar(
            context,
            params.body.name.toString(),
            const Duration(milliseconds: 700)
        );
      });
    } else {
      onStatusChangeSubscription?.cancel();
      onStatusChangeSubscription = null;
    }
  }

  Future navigateToParticipantScreen(BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ParticipantScreen())
    );
    setState(() => isJoining = false);
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
