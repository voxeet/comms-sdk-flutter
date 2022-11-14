import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';

class ParticipantSpatialValues {

  String id;
  SpatialPosition? spatialPosition;
  SpatialDirection? spatialDirection;

  ParticipantSpatialValues(this.id, this.spatialPosition, this.spatialDirection);
}