import 'dart:async';
import '../dolbyio_comms_sdk_flutter_platform_interface.dart';
import '../dolbyio_comms_sdk_native_events.dart';
import '../mapper/mapper.dart';
import 'models/enums.dart';
import 'models/file_presentation.dart';

/// The FilePresentationService allows presenting files during a conference. The Dolby.io Communications APIs service converts the user-provided file into multiple pages that are accessible through the [getImage] method.
///
/// **The file presentation workflow:**
///
/// 1. The presenter calls the [convert] method to upload and convert a file.
///
/// 2. The presenter receives the [FilePresentationServiceEventNames.fileConverted] event when the file conversion is finished.
///
/// 3. The presenter calls the [start] method to start presenting the file.
///
/// 4. The presenter and the viewers receive the [FilePresentationServiceEventNames.filePresentationStarted] event that informs that the file presentation is started.
///
/// 5. The presenter calls the [getImage] method to get the URL of the converted file and display the proper page of the file by retrieving the individual images.
///
/// 6. The application is responsible for coordinating the page flip between the local and the presented files. The presenter calls the [setPage] method to inform the service to send the updated page number to other participants.
///
/// 7. The presenter and viewers receive the [FilePresentationServiceEventNames.filePresentationUpdated] event with the current page number. Receiving the event should trigger calling the [getImage] method to display the proper page of the file by retrieving the individual images.
///
/// 8. The presenter calls the [stop] method to end the file presentation.
///
/// 9. The presenter and the viewers receive the [FilePresentationServiceEventNames.filePresentationStopped] event that informs about the end of the file presentation.
/// 
/// {@category Services}
class FilePresentationService {
  /// @internal
  final _methodChannel = DolbyioCommsSdkFlutterPlatform.createMethodChannel(
      "file_presentation_service");

  /// @internal
  late final _nativeEventsReceiver = DolbyioCommsSdkNativeEventsReceiver<
          FilePresentationServiceEventNames>.forModuleNamed(
      "file_presentation_service");

  /// Converts a provided [file] into multiple images. The file is uploaded as FormData.
  ///
  /// The supported file formats are:
  /// - doc/docx (Microsoft Word)
  /// - ppt/pptx
  /// - pdf
  ///
  /// After the conversion, the files are broken into individual images with a maximum resolution of 2560x1600.
  ///
  Future<FileConverted> convert(File file) async {
    var result = await _methodChannel.invokeMethod<Map<Object?, Object?>>(
        "convert", file.toJson());
    return Future.value(
        result != null ? FileConvertedMapper.fromMap(result) : null);
  }

  /// Returns information about the current state of the file presentation.
  Future<FilePresentation> getCurrent() async {
    var result =
        await _methodChannel.invokeMethod<Map<Object?, Object?>>("getCurrent");
    return Future.value(
        result != null ? FilePresentationMapper.fromMap(result) : null);
  }

  /// Provides the image URL that refers to a specific page of the presented file.
  /// The [page] parameter refers to the number of the presented page. Files that do not consist of pages, for example, jpg images, require setting the value of this parameter to 0.
  Future<String> getImage(int page) async {
    return await _methodChannel.invokeMethod("getImage", {"page": page});
  }

  /// Provides the URL of a thumbnail that refers to a specific page of the presented file.
  /// The [page] parameter refers to the number of the presented page. Files that do not consist of pages, for example, jpg images, require setting the value of this parameter to 0.
  Future<String> getThumbnail(int page) async {
    return await _methodChannel.invokeMethod("getThumbnail", {"page": page});
  }

  /// Informs the service to send the updated page number to conference participants.
  /// The [page] parameter refers to a required page number.
  Future<void> setPage(num page) async {
    await _methodChannel.invokeMethod("setPage", {"page": page});
    return Future.value();
  }

  /// Starts presenting a converted file.
  /// The [fileConverted] parameter refers to the file to be presented.
  Future<void> start(FileConverted fileConverted) async {
    await _methodChannel.invokeMethod("start", fileConverted.toJson());
    return Future.value();
  }

  /// Stops a file presentation.
  Future<void> stop() async {
    await _methodChannel.invokeMethod("stop");
    return Future.value();
  }

  /// Returns a [Stream] of the [FilePresentationServiceEventNames.fileConverted] events. By subscribing to the returned stream you will be notified about finished file conversions.
  Stream<Event<FilePresentationServiceEventNames, FileConverted>>
      onFileConverted() {
    return _nativeEventsReceiver.addListener(
        [FilePresentationServiceEventNames.fileConverted]).map((map) {
      final event = map as Map<Object?, Object?>;
      final key =
          FilePresentationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, FileConvertedMapper.fromMap(data));
    });
  }

  /// Returns a [Stream] of the [FilePresentationServiceEventNames.filePresentationStarted], [FilePresentationServiceEventNames.filePresentationStopped], and [FilePresentationServiceEventNames.filePresentationUpdated] events. By subscribing to the returned stream you will be notified about started, modified, and stopped file presentations.
  Stream<Event<FilePresentationServiceEventNames, FilePresentation>>
      onFilePresentationChange() {
    var events = [
      FilePresentationServiceEventNames.filePresentationStarted,
      FilePresentationServiceEventNames.filePresentationStopped,
      FilePresentationServiceEventNames.filePresentationUpdated
    ];
    return _nativeEventsReceiver.addListener(events).map((map) {
      final event = map as Map<Object?, Object?>;
      final key =
          FilePresentationServiceEventNames.valueOf(event["key"] as String);
      final data = event["body"] as Map<Object?, Object?>;
      return Event(key, FilePresentationMapper.fromMap(data));
    });
  }
}
