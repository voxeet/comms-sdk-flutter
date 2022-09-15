import '../../conference_ext.dart';
import '../../widgets/status_snackbar.dart';
import '../test_buttons/test_buttons.dart';
import 'conference_controls.dart';
import 'conference_title.dart';
import '/screens/test_buttons/test_buttons.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'participant_grid.dart';
import '/widgets/dolby_title.dart';
import '/widgets/modal_bottom_sheet.dart';

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({Key? key}) : super(key: key);

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
              children:   const [
                DolbyTitle(title: 'Dolby.io', subtitle: 'Flutter SDK'),
                ParticipantScreenContent()
              ]
          ),
        ),
      ),
    );
  }
}

class ParticipantScreenContent extends StatefulWidget {
  const ParticipantScreenContent({Key? key}) : super(key: key);

  @override
  State<ParticipantScreenContent> createState() => _ParticipantScreenContentState();
}

class _ParticipantScreenContentState extends State<ParticipantScreenContent> {

  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  final VideoViewController _localParticipantVideoViewController = VideoViewController();
  StreamSubscription<Event<ConferenceServiceEventNames, Participant>>? _participantsChangeSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, StreamsChangeData>>? _streamsChangeSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, List<ConferencePermission>>>? _onPermissionsChangeSubsription;

  Participant? _localParticipant;
  bool shouldCloseSessionOnLeave = false;
  
  @override
  void initState() {
    super.initState();
    _participantsChangeSubscription = 
      _dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange().listen((event) {
        _updateLocalView();
        StatusSnackbar.buildSnackbar(
            context,
            "${event.body.info?.name}: ${event.body.status?.encode()}",
            const Duration(seconds: 1)
        );
      });

    _streamsChangeSubscription = 
      _dolbyioCommsSdkFlutterPlugin.conference.onStreamsChange().listen((event) {
        _updateLocalView();
      });

    _onPermissionsChangeSubsription =
        _dolbyioCommsSdkFlutterPlugin.conference.onPermissionsChange().listen((event) {
          StatusSnackbar.buildSnackbar(
              context,
              event.body.toString(),
              const Duration(seconds: 2)
          );
        });
      ConferenceControls(conference: getCurrentConference(), updateCloseSessionFlag: (shouldCloseSession) {
          shouldCloseSessionOnLeave = shouldCloseSession;
      });

  }

  @override
  void deactivate() {
    _participantsChangeSubscription?.cancel();
    var options = ConferenceLeaveOptions(shouldCloseSessionOnLeave);
    _dolbyioCommsSdkFlutterPlugin.conference.leave(options: options);
    _streamsChangeSubscription?.cancel();
    _onPermissionsChangeSubsription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget videoView = const FlutterLogo();
    if (_localParticipant != null) {
      videoView = VideoView(videoViewController: _localParticipantVideoViewController);
    }

    return Expanded(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12))
          ),
          child: Column(
            children: [
              ConferenceTitle(conference: getCurrentConference()),
              Expanded(
                child: Stack(
                  children: [
                    const ParticipantGrid(),
                    Positioned(
                      left: 10, bottom: 10,
                      width: 100, height: 140,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.blueGrey),
                        child: videoView,
                      )
                    ),
                  ]
                )
              ),
              const ModalBottomSheet(child: TestButtons()),
              ConferenceControls(conference: getCurrentConference(), updateCloseSessionFlag: (shouldCloseSession) => shouldCloseSessionOnLeave),
            ],
          ),
        ),
      );
  }

  Future<Conference?> getCurrentConference() async {
    try {
      return await _dolbyioCommsSdkFlutterPlugin.conference.current();
    } catch(error) {
        return null;
    }
  }

  Future<void> _updateLocalView() async {
    final navigator = Navigator.of(context);
    final currentConference = await getCurrentConference();
    if(currentConference == null) {
      navigator.popUntil(ModalRoute.withName("JoinConferenceScreen"));
      return Future.value();
    }
    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin.conference
      .getParticipants(currentConference);
    final localParticipant = await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
    if (localParticipant.status == ParticipantStatus.left ||
        localParticipant.status == ParticipantStatus.kicked) {
      navigator.popUntil(ModalRoute.withName("JoinConferenceScreen"));
      return Future.value();
    }
    final availableParticipants = conferenceParticipants.where(
      (element) => element.status != ParticipantStatus.left
    );
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

}
