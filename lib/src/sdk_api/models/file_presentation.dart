import 'participant.dart';

/// The File class gathers information about a file that a presenter wants to share during a conference.
/// 
/// {@category Models}
class File {
  /// The local path of a file.
  String uri;

  File(this.uri);

  Map<String, Object?> toJson() => {
        "uri": uri,
      };
}

/// The FileConverted class gathers information about a converted file.
/// 
/// {@category Models}
class FileConverted {
  /// The file ID.
  String id;

  /// The number of images within the converted file.
  int imageCount;

  /// The file name.
  String? name;

  /// The ID of the participant who converted the file.
  String? ownerId;

  /// The size of the converted file.
  num? size;

  FileConverted(this.id, this.imageCount, this.name, this.ownerId, this.size);

  Map<String, Object?> toJson() => {
        "id": id,
        "imageCount": imageCount,
        "name": name,
        "ownerId": ownerId,
        "size": size
      };
}

/// The FilePresentation class gathers information about a file presentation.
/// 
/// {@category Models}
class FilePresentation {
  /// The file ID.
  String id;

  /// The number of images within the file presentation.
  int imageCount;

  /// The file owner.
  Participant owner;

  /// The number of the currently displayed image.
  int position;

  FilePresentation(this.id, this.imageCount, this.owner, this.position);

  Map<String, Object?> toJson() => {
        "id": id,
        "imageCount": imageCount,
        "owner": owner.toJson(),
        "position": position,
      };
}
