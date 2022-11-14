import 'dart:collection';
import 'dart:core';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:dolbyio_comms_sdk_flutter_example/widgets/spatial_extensions/participant_spatial_values.dart';
import 'package:flutter/cupertino.dart';

class SpatialValuesModel extends ChangeNotifier {
  List<ParticipantSpatialValues> _listOfParticipantSpatialValues =
      <ParticipantSpatialValues>[];
  SpatialDirection _localSpatialDirection = SpatialDirection(0.0, 0.0, 0.0);
  SpatialScale _spatialScaleForEnvironment = SpatialScale(1.0, 1.0, 1.0);
  SpatialPosition _forwardPositionForEnvironment =
      SpatialPosition(0.0, 0.0, 1.0);
  SpatialPosition _upPositionForEnvironment = SpatialPosition(0.0, 1.0, 0.0);
  SpatialPosition _rightPositionForEnvironment = SpatialPosition(1.0, 0.0, 0.0);

  SpatialDirection get localSpatialDirection => _localSpatialDirection;
  List<ParticipantSpatialValues> get listOfParticipantSpatialValues =>
      UnmodifiableListView(_listOfParticipantSpatialValues);
  SpatialScale get spatialScaleForEnvironment => _spatialScaleForEnvironment;
  SpatialPosition get forwardPositionForEnvironment =>
      _forwardPositionForEnvironment;
  SpatialPosition get upPositionForEnvironment => _upPositionForEnvironment;
  SpatialPosition get rightPositionForEnvironment =>
      _rightPositionForEnvironment;

  void updateLocalSpatialDirection(SpatialDirection spatialDirection) {
    _localSpatialDirection = spatialDirection;
    notifyListeners();
  }

  void updateLocalSpatialEnvironment(
      SpatialScale spatialScale,
      SpatialPosition forwardPosition,
      SpatialPosition upPosition,
      SpatialPosition rightPosition) {
    _spatialScaleForEnvironment = spatialScale;
    _forwardPositionForEnvironment = forwardPosition;
    _upPositionForEnvironment = upPosition;
    _rightPositionForEnvironment = rightPosition;
    notifyListeners();
  }

  void addParticipantSpatialValues(Participant participant) {
    ParticipantSpatialValues participantSpatialValues =
        ParticipantSpatialValues(
            participant.id, SpatialPosition(0.0, 0.0, 0.0), null);
    _listOfParticipantSpatialValues.add(participantSpatialValues);
    notifyListeners();
  }

  void copyList(List<ParticipantSpatialValues> list) {
    _listOfParticipantSpatialValues = list;
  }

  void updateParticipantSpatialValues(
      Participant participant, SpatialPosition spatialPosition) {
    ParticipantSpatialValues participantSpatial =
        _listOfParticipantSpatialValues
            .where((element) => element.id == participant.id)
            .first;
    participantSpatial.spatialPosition = spatialPosition;
    notifyListeners();
  }

  void clearSpatialValues() {
    _listOfParticipantSpatialValues.clear();
    _localSpatialDirection = SpatialDirection(0.0, 0.0, 0.0);
    _spatialScaleForEnvironment = SpatialScale(1.0, 1.0, 1.0);
    _forwardPositionForEnvironment = SpatialPosition(0.0, 0.0, 1.0);
    _upPositionForEnvironment = SpatialPosition(0.0, 1.0, 0.0);
    _rightPositionForEnvironment = SpatialPosition(1.0, 0.0, 0.0);
  }
}
