/// The SpatialPosition class represents a participant's audio position. The position is defined using Cartesian coordinates.
///
/// You can define the direction of each axis in the coordinate system using the [ConferenceService.setSpatialEnvironment] method. By default, the environment consists of the following axes:
///
/// - X-axis: Extends positive to the right
/// - Y-axis: Extends positive upwards
/// - Z-axis: Extends positive forwards
///
/// The [ConferenceService.setSpatialEnvironment] method allows the application to choose the meaning of each axis and match the usage of the application.
class SpatialPosition {
  /// The x-coordinate of a new audio location.
  double x;
  /// The y-coordinate of a new audio location.
  double y;
  /// The z-coordinate of a new audio location.
  double z;

  SpatialPosition(this.x, this.y, this.z);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
    "x": x,
    "y": y,
    "z": z
  };
}

/// The SpatialScale class defines how to convert units from the application's coordinate system (pixels or centimeters) into meters used by the spatial audio coordinate system. For example, let's assume that SpatialScale is set to (100,100,100), which indicates that 100 of the applications units (cm) map to 1 meter for the audio coordinates. If the listener's location is (0,0,0)cm and a remote participant's location is (200,200,200)cm, the listener has an impression of hearing the remote participant from the (2,2,2)m location.
///
///**Note**: A scale value must have a value greater than zero. The default is (1,1,1).
class SpatialScale {
  /// The x component of the SpatialScale vector.
  double x;
  /// The y component of the SpatialScale vector.
  double y;
  /// The z component of the SpatialScale vector.
  double z;

  SpatialScale(this.x, this.y, this.z);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
    "x": x,
    "y": y,
    "z": z
  };
}

/// The SpatialDirection class defines the direction a participant is facing. The class is specified as a set of three Euler rotations about the corresponding axis. The following properties define a rotation about the specified positive axis:
///
/// - `x`: A rotation about the x-axis
/// - `y`: A rotation about the y-axis
/// - `z`: A rotation about the z-axis
/// 
/// <div class="grid-container"><div class="video-1" > <p><b>Yaw:</b> A rotation about the up axis, where the default environment is the y rotation</p><video controls width="200"> <source src="https://s3.us-west-1.amazonaws.com/static.dolby.link/videos/readme/communications/spatial/08_SpatialDirectionYaw_v03_220131.mp4" type="video/mp4"> Sorry, your browser doesn't support embedded videos.</video></div><div class="video-2"> <p><b>Pitch:</b> A rotation about the right axis, where the default environment is the x rotation.</p><video controls width="200"> <source src="https://s3.us-west-1.amazonaws.com/static.dolby.link/videos/readme/communications/spatial/09_SpatialDirectionPitch_v03_220131.mp4" type="video/mp4"> Sorry, your browser doesn't support embedded videos.</video></div><div class="video-3"> <p><b>Roll:</b> A rotation about the forward axis, where the default environment is the z rotation.</p><video controls width="200"> <source src="https://s3.us-west-1.amazonaws.com/static.dolby.link/videos/readme/communications/spatial/10_SpatialDirectionRoll_v03_220131.mp4" type="video/mp4"> Sorry, your browser doesn't support embedded videos.</video></div><br></div><style> .grid-container { display: grid; }.grid-container {display: grid;grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));grid-column-gap: 10px;grid-row-gap: 30px;}</style>
/// 
/// When using custom environment directions set in [ConferenceService.setSpatialEnvironment], the rotation is defined to always rotate about the relevant axis according to the left handed curl rule. In the animations above you can see, for the y-axis rotation, if you curl your left hand up around with your thumb pointing down the +y axis, the direction the participant will rotate is in the direction the fingers are curling around the given axis. You can see the rotation arrows in those reference animations which correspond to positive rotation direction are pointing the same direction as the fingers of the curled left hand.
///
/// When a direction contains rotations around more than one axis, the rotations are applied in a defined order: yaw, pitch, and then roll. With the standard environment, this corresponds to y, x, and then z. When using custom environment directions, the directions are always in the order of yaw/pitch/roll, but which (x,y,z) axis those correspond to is different.
class SpatialDirection {
  /// The Euler rotation about the x-axis, in degrees.
  double x;
  /// The Euler rotation about the y-axis, in degrees.
  double y;
  /// The Euler rotation about the z-axis, in degrees.
  double z;

  SpatialDirection(this.x, this.y, this.z);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
    "x": x,
    "y": y,
    "z": z
  };
}
