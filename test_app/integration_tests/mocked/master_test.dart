// import 'audio_preview_test.dart';
import 'conference_service_test.dart';
import 'command_service_test.dart';
import 'audio_service_test.dart';
import 'file_presentation_service_test.dart';
import 'media_device_service_test.dart';
import 'notification_service_test.dart';
import 'recording_service_test.dart';
import 'sdk_test.dart';
import 'video_presentation_service_test.dart';
import 'video_service_test.dart';

void main() {
  conferenceServiceTest();
  commandServiceTest();
  audioServiceTest();
  filePresentationServiceTest();
  mediaDeviceServiceTest();
  notificationServiceTest();
  recordingServiceTest();
  sdkTest();
  videoPresentationServiceTest();
  videoServiceTest();
  // audioPreviewTest();
}
