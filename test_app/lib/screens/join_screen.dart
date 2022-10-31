import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/status_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import '../shared_preferences_helper.dart';
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
  bool spatialAudio = false;
  bool switchDolbyVoice = true;
  String? spatialAudioStyleDropDownText;
  SpatialAudioStyle spatialAudioStyle = SpatialAudioStyle.disabled;
  static const String spatialAudioWithIndividual =
      "Spatial Audio with Individual";
  static const String spatialAudioWithSharedScene =
      "Spatial Audio with Shared Scene";
  static const String spatialAudioDisabled = "Spatial Audio Disabled";
  bool joinAsListener = false;
  String _conferenceAlias = '';

  StreamSubscription<
          Event<NotificationServiceEventNames,
              InvitationReceivedNotificationData>>?
      onInvitationReceivedSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>?
      onStatusChangeSubscription;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
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
                    focusColor: Colors.deepPurple,
                    isStorageNeeded: true,
                    onStorageIconTap: () async {
                      await showAliasSelectorDialog(
                        context,
                        SharedPreferencesHelper().conferenceAliases,
                      );
                    },
                  ),
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
                                spatialAudio = value;
                              });
                            } else {
                              setState(() => switchDolbyVoice = value);
                            }
                          }),
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
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        value: switchDolbyVoice
                            ? spatialAudioStyleDropDownText
                            : null,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: <String>[
                          spatialAudioWithIndividual,
                          spatialAudioWithSharedScene,
                          spatialAudioDisabled,
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: const Text(
                          "Spatial Audio Style",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (String? value) {
                          if (switchDolbyVoice == true &&
                              value == spatialAudioWithIndividual) {
                            setState(() {
                              spatialAudioStyle =
                                  SpatialAudioStyle.individual;
                              spatialAudio = true;
                              spatialAudioStyleDropDownText = value;
                            });
                          } else if (switchDolbyVoice == true &&
                              value == spatialAudioWithSharedScene) {
                            setState(() {
                              spatialAudioStyle = SpatialAudioStyle.shared;
                              spatialAudio = true;
                              spatialAudioStyleDropDownText = value;
                            });
                          } else if (switchDolbyVoice == true &&
                              value == spatialAudioDisabled) {
                            setState(() {
                              spatialAudioStyle =
                                  SpatialAudioStyle.disabled;
                              spatialAudio = false;
                              spatialAudioStyleDropDownText = value;
                            });
                          } else {
                            spatialAudioStyle = SpatialAudioStyle.disabled;
                            spatialAudioStyleDropDownText = null;
                            spatialAudio = false;
                          }
                        },
                      ),
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
    _conferenceAlias = conferenceAliasTextController.text;
    var params = ConferenceCreateParameters();
    params.dolbyVoice = switchDolbyVoice;
    params.liveRecording = true;
    var createOptions =
        ConferenceCreateOption(_conferenceAlias, params, 0, spatialAudioStyle);
    createOptions.spatialAudioStyle = spatialAudioStyle;
    return createOptions;
  }

  ConferenceJoinOptions conferenceJoinOptions() {
    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);
    joinOptions.maxVideoForwarding = 4;
    joinOptions.spatialAudio = spatialAudio;
    joinOptions.mixing = ConferenceMixingOptions(switchDolbyVoice);
    return joinOptions;
  }

  ConferenceListenOptions conferenceListenOptions() {
    var listenOptions = ConferenceListenOptions();
    listenOptions.maxVideoForwarding = 4;
    listenOptions.spatialAudio = spatialAudio;
    return listenOptions;
  }

  void checkJoinConferenceResult(Conference conference) {
    if (conference.status == ConferenceStatus.joined) {
      navigateToParticipantScreen(context, conference);
    } else {
      developer.log('Cannot join to conference.');
    }
    saveToSharedPreferences();
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
              conference: conference, isSpatialAudio: spatialAudio)),
    );
    setState(() => isJoining = false);
  }

  Future<void> showAliasSelectorDialog(
    BuildContext context,
    List<String>? conferenceAliases,
  ) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Choose from recently saved'),
              actionsOverflowButtonSpacing: 10,
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (conferenceAliases != null)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: conferenceAliases.length,
                          itemBuilder: (context, index) {
                            String alias = conferenceAliases[index];
                            return ListTile(
                              title: Text(alias),
                              onTap: () => onAliasTap(alias),
                            );
                          },
                        )
                      else
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('No aliases in storage.'),
                        )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.deepPurple),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ]);
        });
  }

  void onAliasTap(String alias) {
    conferenceAliasTextController.text = alias;
    Navigator.of(context).pop();
  }

  void initSharedPreferences() {
    try {
      conferenceAliasTextController.text =
          SharedPreferencesHelper().latestAlias;
    } catch (error) {
      onError('Cannot load data from shared preferences.', error);
    }
  }

  void saveToSharedPreferences() {
    SharedPreferencesHelper().latestAlias = _conferenceAlias;
  }

  void onError(String message, Object? error) {
    developer.log(message, error: error);
  }
}
