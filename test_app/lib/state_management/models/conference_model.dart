import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';

class ConferenceModel extends ChangeNotifier {
  late Conference _conference;
  late Conference _replayedConference;
  String _username = "";
  String? _externalId = "";
  bool _isReplayConference = false;
  bool _isSomeonePresentingVideo = false;
  String _imageSource = '';
  int _amountOfPagesInDocument = 0;

  Conference get conference => _conference;
  Conference get replayedConference => _replayedConference;
  String get username => _username;
  String? get externalId => _externalId;
  bool get isReplayConference => _isReplayConference;
  bool get isSomeonePresentingVideo => _isSomeonePresentingVideo;
  String get imageSource => _imageSource;
  int get amountOfPagesInDocument => _amountOfPagesInDocument;

  set conference(Conference value) {
    _conference = value;
    notifyListeners();
  }

  set replayedConference(Conference value) {
    _conference = value;
    notifyListeners();
  }

  set username(String value) {
    _username = value;
    notifyListeners();
  }

  set externalId(String? value) {
    _externalId = value;
    notifyListeners();
  }

  set isReplayConference(bool value) {
    _isReplayConference = value;
    notifyListeners();
  }

  set isSomeonePresentingVideo(bool value) {
    _isSomeonePresentingVideo = value;
    notifyListeners();
  }

  set imageSource(String value) {
    _imageSource = value;
    notifyListeners();
  }

  set amountOfPagesInDocument(int value) {
    _amountOfPagesInDocument = value;
    notifyListeners();
  }

  void updateConference() async {
    final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
    _conference = await dolbyioCommsSdkFlutterPlugin.conference.current();
  }
}
