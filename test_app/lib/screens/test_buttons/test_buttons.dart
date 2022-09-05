import 'package:flutter/material.dart';
import 'conference_service_test_buttons.dart';
import 'recording_service_test_buttons.dart';
import 'media_device_service_test_buttons.dart';
import 'command_service_test_buttons.dart';
import 'file_presentation_service_test_buttons.dart';
import 'video_presentation_service_test_buttons.dart';
import 'notification_service_test_buttons.dart';

class TestButtons extends StatelessWidget {

  const TestButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 10),
              const Text("Conference service"),
              const SizedBox(height: 10),
              ConferenceServiceTestButtons(),
              const SizedBox(height: 10),
              const Text("Recording service"),
              const SizedBox(height: 10),
              RecordingServiceTestButtons(),
              const SizedBox(height: 10),
              const Text("Media Device service"),
              const SizedBox(height: 10),
              MediaDeviceServiceTestButtons(),
              const SizedBox(height: 10),
              const Text("Command service"),
              const SizedBox(height: 10),
              CommandServiceTestButtons(),
              const SizedBox(height: 10),
              const Text("File presentation service"),
              const SizedBox(height: 10),
              const FilePresentationServiceTestButtons(),
              const SizedBox(height: 10),
              const Text("Video presentation service"),
              const SizedBox(height: 10),
              const VideoPresentationServiceTestButtons(),
              const SizedBox(height: 10),
              const Text("Notification service"),
              const SizedBox(height: 10),
              const NotificationServiceTestButtons()
            ],
          ),
        ),
      ),
    );
  }
}
