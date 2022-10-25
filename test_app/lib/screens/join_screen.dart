import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/status_snackbar.dart';
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
import '/widgets/switch_option.dart';
import '/permission_helper.dart';
import 'participant_screen/participant_screen.dart';
import 'dart:developer' as developer;
import 'replay_screen.dart';

class JoinConference extends StatelessWidget {
  final String username;
  final String externalId;

  const JoinConference(
      {Key? key, required this.username, required this.externalId})
      : super(key: key);

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
                  JoinConferenceContent(
                      username: username, externalId: externalId)
                ],
              ))),
    );
  }
}

class JoinConferenceContent extends StatefulWidget {
  final String username;
  final String externalId;

  const JoinConferenceContent(
      {Key? key, required this.username, required this.externalId})
      : super(key: key);

  @override
  State<JoinConferenceContent> createState() => _JoinConferenceContentState();
}

class _JoinConferenceContentState extends State<JoinConferenceContent> {
  final TextEditingController conferenceAliasTextController =
      TextEditingController();
  final TextEditingController conferenceIdTextController =
      TextEditingController();
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  final formKeyAlias = GlobalKey<FormState>();
  final formKeyId = GlobalKey<FormState>();
  bool isJoining = false;
  bool isReplaying = false;
  bool switchConferenceStatus = false;
  bool switchSpatialAudio = false;
  bool switchDolbyVoice = false;
  bool joinAsListener = false;
  StreamSubscription<
          Event<NotificationServiceEventNames,
              InvitationReceivedNotificationData>>?
      onInvitationReceivedSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>?
      onStatusChangeSubscription;

  @override
  void initState() {
    super.initState();

    onInvitationReceivedSubscription = _dolbyioCommsSdkFlutterPlugin
        .notification
        .onInvitationReceived()
        .listen((params) {
      showInvitationDialog(context, params.body.toJson().toString(),
          params.body.conferenceId.toString());
    });
  }

  @override
  void dispose() {
    onInvitationReceivedSubscription?.cancel();
    onStatusChangeSubscription?.cancel();
    super.dispose();
  }

  Future<void> showInvitationDialog(
      BuildContext context, String body, String conferenceId) async {
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
                  child: const Text("Join")),
              ElevatedButton(
                  onPressed: () {
                    declineInvitation(conferenceId);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Decline")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TwoColorText(
                    blackText: "Logged in as ", colorText: widget.username),
                TwoColorText(
                    blackText: "External ID  ", colorText: widget.externalId),
                const SizedBox(height: 16),
                Form(
                  key: formKeyAlias,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: InputTextFormField(
                      labelText: 'Conference alias',
                      controller: conferenceAliasTextController,
                      focusColor: Colors.deepPurple),
                ),
                ExpansionTile(
                    title: const Text('Options'),
                    textColor: Colors.black,
                    iconColor: Colors.deepPurple,
                    children: [
                      SwitchOption(
                          title: 'Observe Conference Status',
                          value: switchConferenceStatus,
                          onChanged: (value) {
                            setState(() {
                              switchConferenceStatus = value;
                              observeConferenceStatus(switchConferenceStatus);
                            });
                          }),
                      SwitchOption(
                          title: 'Dolby Voice',
                          value: switchDolbyVoice,
                          onChanged: (value) {
                            if (value == false) {
                              setState(() {
                                switchDolbyVoice = value;
                                switchSpatialAudio = value;
                              });
                            } else {
                              setState(() => switchDolbyVoice = value);
                            }
                          }),
                      SwitchOption(
                          title: 'Spatial audio',
                          value: switchSpatialAudio,
                          onChanged: switchDolbyVoice
                              ? (value) {
                                  setState(() => switchSpatialAudio = value);
                                }
                              : null),
                      SwitchOption(
                          title: 'Join as listener',
                          value: joinAsListener,
                          onChanged: (value) {
                            if (value == false) {
                              setState(() {
                                joinAsListener = value;
                              });
                            } else {
                              setState(() => joinAsListener = value);
                            }
                          }),
                    ]),
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
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                Form(
                    key: formKeyId,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: InputTextFormField(
                        labelText: 'Conference ID with record',
                        controller: conferenceIdTextController,
                        focusColor: Colors.deepPurple)),
                const SizedBox(height: 16),
                PrimaryButton(
                  widgetText: isReplaying
                      ? const WhiteCircularProgressIndicator()
                      : const Text('Replay conference'),
                  onPressed: () {
                    onReplayButtonPressed();
                  },
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkPermissions() {
    Permissions.checkPermissions(
      permissions: [
        Permission.camera,
        Permission.microphone,
        Permission.bluetoothConnect
      ],
      onGranted: () => onJoinButtonPressed(),
      onPermanentlyDenied: (permissions) async {
        await ViewDialogs.dialog(
          context: context,
          title: 'Permissions missing',
          body:
              'Required permissions $permissions were denied. Please enable them manually.',
          okText: 'Open settings',
          cancelText: 'Cancel',
          result: (value) => value ? openAppSettings() : null,
        );
      },
      onDenied: (permissions) {
        Fluttertoast.showToast(
            msg: "Permissions $permissions missing, can't continue");
      },
    );
  }

  void onJoinButtonPressed() {
    final isValidForm = formKeyAlias.currentState!.validate();
    if (isValidForm) {
      setState(() => isJoining = true);
      if (joinAsListener) {
        listen();
      } else {
        join();
      }
    } else {
      developer.log('Cannot join to conference due to error.');
    }
  }

  void onReplayButtonPressed() {
    final isValidForm = formKeyId.currentState!.validate();
    if (isValidForm) {
      setState(() => isReplaying = true);
      replay();
    } else {
      developer.log('Cannot replay the conference due to error.');
    }
  }

  void join() {
    create().then((value) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .join(value, conferenceJoinOptions())
          .then((value) => checkJoinConferenceResult(value))
          .onError((error, stackTrace) =>
              onError('Error during joining conference.', error));
    });
  }

  void listen() {
    create().then((value) {
      _dolbyioCommsSdkFlutterPlugin.conference
          .listen(value, conferenceListenOptions())
          .then((value) => checkJoinConferenceResult(value))
          .onError((error, stackTrace) =>
              onError('Error during joining conference.', error));
    });
  }

  Future<Conference> create() {
    var conference = _dolbyioCommsSdkFlutterPlugin.conference
        .create(conferenceCreateOptions());
    return conference;
  }

  ConferenceCreateOption conferenceCreateOptions() {
    var conferenceName = conferenceAliasTextController.text;
    var params = ConferenceCreateParameters();
    params.dolbyVoice = switchDolbyVoice;
    params.liveRecording = true;
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

  ConferenceListenOptions conferenceListenOptions() {
    var listenOptions = ConferenceListenOptions();
    listenOptions.maxVideoForwarding = 4;
    listenOptions.spatialAudio = switchSpatialAudio;
    return listenOptions;
  }

  void checkJoinConferenceResult(Conference conference) {
    if (conference.status == ConferenceStatus.joined) {
      navigateToParticipantScreen(context, conference);
    } else {
      developer.log('Cannot join to conference.');
    }
  }

  void joinInvitation(String conferenceId) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .fetch(conferenceId)
        .then((value) => {
              _dolbyioCommsSdkFlutterPlugin.conference
                  .join(value, conferenceJoinOptions())
                  .then((value) => checkJoinConferenceResult(value))
                  .onError((error, stackTrace) =>
                      onError('Error during joining conference.', error))
            });
  }

  void declineInvitation(String conferenceId) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .fetch(conferenceId)
        .then((conference) =>
            _dolbyioCommsSdkFlutterPlugin.notification.decline(conference))
        .onError(
            (error, stackTrace) => onError('Error during declining.', error));
  }

  void observeConferenceStatus(bool switchValue) {
    if (switchValue == true) {
      onStatusChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
          .onStatusChange()
          .listen((params) {
        StatusSnackbar.buildSnackbar(context, params.body.name.toString(),
            const Duration(milliseconds: 700));
      });
    } else {
      onStatusChangeSubscription?.cancel();
      onStatusChangeSubscription = null;
    }
  }

  void replay() {
    _dolbyioCommsSdkFlutterPlugin.conference
        .fetch(conferenceIdTextController.text)
        .then(
          (conference) => _dolbyioCommsSdkFlutterPlugin.conference
              .replay(conference: conference)
              .then((conference) => checkReplayConferenceResult(conference)),
        )
        .onError(
          (error, stackTrace) => developer.log(error.toString()),
        );
  }

  void checkReplayConferenceResult(Conference conference) {
    if (conference.id != null) {
      navigateToReplayScreen(context, conference);
    } else {
      developer.log('Cannot replay the conference.');
    }
  }

  Future navigateToReplayScreen(
    BuildContext context,
    Conference conference,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ReplayScreen(conference: conference)),
    );
    setState(() => isReplaying = false);
  }

  Future navigateToParticipantScreen(
      BuildContext context, Conference conference) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ParticipantScreen(
              conference: conference, isSpatialAudio: switchSpatialAudio)),
    );
    setState(() => isJoining = false);
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
