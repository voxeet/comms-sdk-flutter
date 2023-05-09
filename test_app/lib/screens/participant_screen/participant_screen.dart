import 'package:dolbyio_comms_sdk_flutter_example/state_management/models/conference_model.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/file_presentation_ui.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/spatial_extensions/participant_spatial_values.dart';
import 'package:provider/provider.dart';
import '../../conference_ext.dart';
import '../../widgets/file_container.dart';
import '../../widgets/spatial_extensions/spatial_values_model.dart';
import '../../widgets/status_snackbar.dart';
import '../test_buttons/test_buttons.dart';
import 'conference_controls.dart';
import 'conference_title.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'participant_grid.dart';
import '/widgets/dolby_title.dart';
import '/widgets/modal_bottom_sheet.dart';

class ParticipantScreen extends StatefulWidget {
  final bool isSpatialAudio;

  const ParticipantScreen({Key? key, required this.isSpatialAudio})
      : super(key: key);

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
            children: [
              const DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
              ParticipantScreenContent(isSpatialAudio: widget.isSpatialAudio),
            ],
          ),
        ),
      ),
    );
  }
}

class ParticipantScreenContent extends StatefulWidget {
  final bool isSpatialAudio;

  const ParticipantScreenContent({Key? key, required this.isSpatialAudio})
      : super(key: key);

  @override
  State<ParticipantScreenContent> createState() =>
      _ParticipantScreenContentState();
}

class _ParticipantScreenContentState extends State<ParticipantScreenContent> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  final VideoViewController _localParticipantVideoViewController =
      VideoViewController();
  final VideoViewController _shareScreenVideoViewController =
      VideoViewController();

  StreamSubscription<Event<ConferenceServiceEventNames, Participant>>?
      _participantsChangeSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, StreamsChangeData>>?
      _streamsChangeSubscription;
  StreamSubscription<
          Event<ConferenceServiceEventNames, List<ConferencePermission>>>?
      _onPermissionsChangeSubsription;

  StreamSubscription<Event<RecordingServiceEventNames, RecordingStatusUpdate>>?
      _onRecordingChangeSubscription;

  StreamSubscription<
          Event<FilePresentationServiceEventNames, FilePresentation>>?
      _onFilePresentationChangeSubscription;

  Participant? _localParticipant;
  bool shouldCloseSessionOnLeave = false;
  List<ParticipantSpatialValues> participants = [];
  bool _isScreenSharing = false;
  bool isFilePresenting = false;
  bool isLocalPresentingFile = false;

  @override
  void initState() {
    super.initState();
    setDefaultSpatialPosition;
    _participantsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
        .onParticipantsChange()
        .listen((event) {
      _updateLocalView();
      _updateShareScreenView();
      updateDefaultSpatialPosition(event.body);
      StatusSnackbar.buildSnackbar(
          context,
          "${event.body.info?.name}: ${event.body.status?.encode()}",
          const Duration(seconds: 1));
    });

    _streamsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
        .onStreamsChange()
        .listen((event) {
      _updateLocalView();
      _updateShareScreenView();
    });

    _onPermissionsChangeSubsription = _dolbyioCommsSdkFlutterPlugin.conference
        .onPermissionsChange()
        .listen((event) {
      StatusSnackbar.buildSnackbar(
          context, event.body.toString(), const Duration(seconds: 2));
    });

    _onRecordingChangeSubscription = _dolbyioCommsSdkFlutterPlugin.recording
        .onRecordingStatusUpdate()
        .listen((event) {
      StatusSnackbar.buildSnackbar(
          context,
          "Recording status: ${event.body.recordingStatus} for conference: ${event.body.conferenceId}",
          const Duration(seconds: 2));
    });

    _onFilePresentationChangeSubscription = _dolbyioCommsSdkFlutterPlugin
        .filePresentation
        .onFilePresentationChange()
        .listen((event) async {
      if (event.type ==
          FilePresentationServiceEventNames.filePresentationStarted) {
        Provider.of<ConferenceModel>(context, listen: false).imageSource =
            await _dolbyioCommsSdkFlutterPlugin.filePresentation
                .getImage(event.body.position);
        var localParticipant = await _dolbyioCommsSdkFlutterPlugin.conference
            .getLocalParticipant();
        setState(() {
          isFilePresenting = true;
          if (event.body.owner.id == localParticipant.id) {
            isLocalPresentingFile = true;
            Provider.of<ConferenceModel>(context, listen: false)
                .amountOfPagesInDocument = event.body.imageCount - 1;
          }
        });
      } else if (event.type ==
          FilePresentationServiceEventNames.filePresentationUpdated) {
        var imageSource = await _dolbyioCommsSdkFlutterPlugin.filePresentation
            .getImage(event.body.position);
        setState(() {
          Provider.of<ConferenceModel>(context, listen: false).imageSource =
              imageSource;
        });
      } else if (event.type ==
          FilePresentationServiceEventNames.filePresentationStopped) {
        setState(() {
          isFilePresenting = false;
          isLocalPresentingFile = false;
        });
      }
    });
  }

  @override
  void deactivate() {
    _participantsChangeSubscription?.cancel();

    var options = ConferenceLeaveOptions(shouldCloseSessionOnLeave);
    _dolbyioCommsSdkFlutterPlugin.conference
        .leave(options: options);
    _streamsChangeSubscription?.cancel();
    _onPermissionsChangeSubsription?.cancel();
    _onRecordingChangeSubscription?.cancel();
    _onFilePresentationChangeSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SpatialValuesModel>(context)
        .setSpatialConferenceState(widget.isSpatialAudio);
    Provider.of<SpatialValuesModel>(context).copyList(participants);

    Widget videoView = const FlutterLogo();
    if (_localParticipant != null) {
      videoView =
          VideoView(videoViewController: _localParticipantVideoViewController);
    }

    Widget screenShareView = const FlutterLogo();
    if (_isScreenSharing) {
      screenShareView =
          VideoView(videoViewController: _shareScreenVideoViewController);
    }

    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          children: [
            const ConferenceTitle(),
            isFilePresenting
                ? isLocalPresentingFile
                    ? const FilePresentationUI()
                    : const SingleChildScrollView(
                        child: FileContainer(),
                      )
                : const SizedBox.shrink(),
            Expanded(
              child: Stack(
                children: [
                  const ParticipantGrid(),
                  Positioned(
                      left: 10,
                      bottom: 10,
                      width: 100,
                      height: 180,
                      child: _isScreenSharing ? screenShareView : videoView),
                  const ModalBottomSheet(child: TestButtons()),
                ],
              ),
            ),
            ConferenceControls(
              updateCloseSessionFlag: (shouldCloseSession) {
                shouldCloseSessionOnLeave = shouldCloseSession;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setDefaultSpatialPosition() async {
    if (widget.isSpatialAudio) {
      final currentConference = await getCurrentConference();
      final availableParticipants = currentConference?.participants
          .where((element) => element.status != ParticipantStatus.left);
      for (var participant in availableParticipants!) {
        _dolbyioCommsSdkFlutterPlugin.conference.setSpatialPosition(
            participant: participant, position: SpatialPosition(0.0, 0.0, 0.0));
        ParticipantSpatialValues participantSpatial = ParticipantSpatialValues(
            participant.id, SpatialPosition(0.0, 0.0, 0.0), null);
        participants.add(participantSpatial);
      }
    }
  }

  void updateDefaultSpatialPosition(Participant participant) {
    if (widget.isSpatialAudio) {
      if (participant.status == ParticipantStatus.onAir ||
          participant.status == ParticipantStatus.connected) {
        _dolbyioCommsSdkFlutterPlugin.conference.setSpatialPosition(
            participant: participant, position: SpatialPosition(0.0, 0.0, 0.0));
        ParticipantSpatialValues participantSpatial = ParticipantSpatialValues(
            participant.id, SpatialPosition(0.0, 0.0, 0.0), null);
        participants.add(participantSpatial);
      }
    }
  }

  Future<Conference?> getCurrentConference() async {
    try {
      return await _dolbyioCommsSdkFlutterPlugin.conference.current();
    } catch (error) {
      return null;
    }
  }

  Future<void> _updateLocalView() async {
    final navigator = Navigator.of(context);
    final currentConference = await getCurrentConference();
    if (currentConference == null) {
      navigator.popUntil(ModalRoute.withName("JoinConferenceScreen"));
      return Future.value();
    }

    if (!mounted) return;
    Provider.of<ConferenceModel>(context, listen: false).conference =
        currentConference;

    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin
        .conference
        .getParticipants(currentConference);
    final localParticipant =
        await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
    final availableParticipants = conferenceParticipants
        .where((element) => element.status != ParticipantStatus.left);
    if (availableParticipants.isNotEmpty) {
      final streams = localParticipant.streams;
      MediaStream? stream;
      if (streams != null) {
        for (final s in streams) {
          if (s.type == MediaStreamType.camera) {
            stream = s;
            break;
          }
        }
      }
      if (stream != null) {
        _localParticipantVideoViewController.attach(localParticipant, stream);
      } else {
        _localParticipantVideoViewController.detach();
      }

      setState(() {
        _localParticipant = localParticipant;
      });
    }
    return Future.value();
  }

  Future<void> _updateShareScreenView() async {
    Provider.of<ConferenceModel>(context, listen: false).updateConference();
    var conference =
        Provider.of<ConferenceModel>(context, listen: false).conference;
    final participants = await _dolbyioCommsSdkFlutterPlugin.conference
        .getParticipants(conference);
    final availableParticipants = participants
        .where((element) => element.status != ParticipantStatus.left);

    MediaStream? mediaStream;
    Participant? streamingParticipant;
    bool isScreenSharing = false;

    if (availableParticipants.isNotEmpty) {
      for (var participant in availableParticipants) {
        var participantStreams = participant.streams;
        if (participantStreams != null) {
          for (var stream in participantStreams) {
            if (stream.type == MediaStreamType.screenShare) {
              streamingParticipant = participant;
              mediaStream = stream;
              setState(() => isScreenSharing = true);
              break;
            }
          }
        }
      }

      if (mediaStream != null && streamingParticipant != null) {
        if (!mounted) return;
        _shareScreenVideoViewController.attach(
            streamingParticipant, mediaStream);
      } else {
        if (!mounted) return;
        _shareScreenVideoViewController.detach();
      }

      setState(() {
        _isScreenSharing = isScreenSharing;
      });
    }

    return Future.value();
  }
}
