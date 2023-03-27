import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/status_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../shared_preferences_helper.dart';
import '../state_management/models/conference_model.dart';
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
  const JoinConference({Key? key}) : super(key: key);

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
              JoinConferenceContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class JoinConferenceContent extends StatefulWidget {
  const JoinConferenceContent({Key? key}) : super(key: key);

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
  bool joiningInProgress = false;
  bool startingConferenceReplay = false;
  bool switchConferenceStatus = false;
  bool spatialAudio = false;
  bool switchDolbyVoice = true;
  bool switchLiveRecording = false;
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
  StreamSubscription<
      Event<NotificationServiceEventNames,
          ConferenceStatusNotificationData>>? onConferenceStatusSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, ConferenceStatus>>?
      onStatusChangeSubscription;

  StreamSubscription<
      Event<NotificationServiceEventNames,
          ConferenceCreatedNotificationData>>? onConferenceCreatedSubscription;

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

    onConferenceStatusSubscription = _dolbyioCommsSdkFlutterPlugin.notification
        .onConferenceStatus()
        .listen((params) {
      StatusSnackbar.buildSnackbar(
          context,
          'Conference Status Event: ${params.body.toJson().toString()}',
          const Duration(milliseconds: 3000));
    });

    onConferenceCreatedSubscription = _dolbyioCommsSdkFlutterPlugin.notification
        .onConferenceCreated()
        .listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("conference created: ${event.body.conferenceAlias}")));
      developer.log("Conference created: ${event.body.conferenceAlias}");
    });
  }

  @override
  void dispose() {
    onInvitationReceivedSubscription?.cancel();
    onConferenceStatusSubscription?.cancel();
    onStatusChangeSubscription?.cancel();
    onConferenceCreatedSubscription?.cancel();
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
                    blackText: "Logged in as: ",
                    colorText: Provider.of<ConferenceModel>(context).username),
                TwoColorText(
                    blackText: "External ID:  ",
                    colorText:
                        Provider.of<ConferenceModel>(context).externalId ?? ""),
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
                              setState(() {
                                switchDolbyVoice = value;
                              });
                            }
                          }),
                      SwitchOption(
                          title: 'Live recording',
                          value: switchLiveRecording,
                          onChanged: (value) {
                            if (value == false) {
                              setState(() {
                                switchLiveRecording = value;
                              });
                            } else {
                              setState(() {
                                switchLiveRecording = value;
                              });
                            }
                          }),
                      SwitchOption(
                          title: 'Join as listener',
                          value: joinAsListener,
                          onChanged: (value) {
                            if (value == false) {
                              setState(() => joinAsListener = value);
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
                              spatialAudioStyle = SpatialAudioStyle.individual;
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
                              spatialAudioStyle = SpatialAudioStyle.disabled;
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
                  widgetText: joiningInProgress
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
                  widgetText: startingConferenceReplay
                      ? const WhiteCircularProgressIndicator()
                      : const Text('Replay'),
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
      onDenied: (permissions) async {
        await ViewDialogs.dialog(
            context: context,
            title: 'Permissions missing',
            body: 'Permissions $permissions missing, cannot continue.',
            okText: 'Ok');
      },
    );
  }

  void onJoinButtonPressed() async {
    setState(() => joiningInProgress = true);
    try {
      final isValidForm = formKeyAlias.currentState!.validate();
      if (isValidForm) {
        Conference conference = joinAsListener ? await listen() : await join();
        saveToSharedPreferences();
        if (!mounted) return;
        Provider.of<ConferenceModel>(context, listen: false).conference =
            conference;
        navigateToParticipantScreen();
      }
    } catch (e) {
      onError('Error: ', e);
    } finally {
      setState(() => joiningInProgress = false);
    }
  }

  void onReplayButtonPressed() async {
    setState(() => startingConferenceReplay = true);
    try {
      final isValidForm = formKeyAlias.currentState!.validate();
      if (isValidForm) {
        final conference = await replay();
        if (conference.id != null) {
          if (!mounted) return;
          Provider.of<ConferenceModel>(context, listen: false)
              .replayedConference = conference;
          navigateToReplayScreen();
        }
      }
    } catch (e) {
      onError('Error: ', e);
    } finally {
      setState(() => startingConferenceReplay = false);
    }
  }

  Future<Conference> join() async {
    Conference conference = await createConference();
    await _dolbyioCommsSdkFlutterPlugin.conference
            .join(conference, conferenceJoinOptions());
    return conference;
  }

  Future<Conference> listen() async {
    Conference conference = await createConference().then((value) =>
        _dolbyioCommsSdkFlutterPlugin.conference
            .listen(value, conferenceListenOptions()));
    return conference;
  }

  Future<Conference> replay() async {
    Conference conference = await _dolbyioCommsSdkFlutterPlugin.conference
        .fetch(conferenceIdTextController.text)
        .then((conference) => _dolbyioCommsSdkFlutterPlugin.conference
            .replay(conference: conference));
    return conference;
  }

  Future<Conference> createConference() async {
    var options = conferenceCreateOptions();
    
    String alias = options.alias != null ? options.alias! : "";
    var subscription =
        SubscriptionType.values.map((e) => Subscription(e, alias)).toList();
    await _dolbyioCommsSdkFlutterPlugin.notification.subscribe(subscription);

    return await _dolbyioCommsSdkFlutterPlugin.conference.create(options);
  }

  ConferenceCreateOption conferenceCreateOptions() {
    _conferenceAlias = conferenceAliasTextController.text;
    var params = ConferenceCreateParameters();
    params.dolbyVoice = switchDolbyVoice;
    params.liveRecording = switchLiveRecording;
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
    return joinOptions;
  }

  ConferenceListenOptions conferenceListenOptions() {
    var listenOptions = ConferenceListenOptions();
    listenOptions.maxVideoForwarding = 4;
    listenOptions.spatialAudio = spatialAudio;
    return listenOptions;
  }

  void joinInvitation(String conferenceId) {
    _dolbyioCommsSdkFlutterPlugin.conference
        .fetch(conferenceId)
        .then((value) => {
              _dolbyioCommsSdkFlutterPlugin.conference
                  .join(value, conferenceJoinOptions())
                  .then((value) => navigateToParticipantScreen())
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

  void navigateToReplayScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReplayScreen(),
      ),
    );
  }

  void navigateToParticipantScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ParticipantScreen(isSpatialAudio: spatialAudio),
      ),
    );
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
