import 'package:dolbyio_comms_sdk_flutter_example/screens/test_buttons/audio_service_test_buttons.dart';
import 'package:dolbyio_comms_sdk_flutter_example/screens/test_buttons/video_service_test_buttons.dart';
import 'package:flutter/material.dart';
import 'command_service_test_buttons.dart';
import 'conference_service_test_buttons.dart';
import 'media_device_service_test_buttons.dart';
import 'notification_service_test_buttons.dart';
import 'recording_service_test_buttons.dart';

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
            children: const [
              SizedBox(height: 10),
              Text("Audio service"),
              SizedBox(height: 10),
              AudioServiceTestButtons(),
              SizedBox(height: 10),
              Text("Conference service"),
              SizedBox(height: 10),
              ConferenceServiceTestButtons(),
              SizedBox(height: 10),
              Text("Recording service"),
              SizedBox(height: 10),
              RecordingServiceTestButtons(),
              SizedBox(height: 10),
              Text("Media Device service"),
              SizedBox(height: 10),
              MediaDeviceServiceTestButtons(),
              SizedBox(height: 10),
              Text("Command service"),
              SizedBox(height: 10),
              CommandServiceTestButtons(),
              SizedBox(height: 10),
              Text("Notification service"),
              SizedBox(height: 10),
              NotificationServiceTestButtons(),
              SizedBox(height: 10),
              Text("Video service"),
              SizedBox(height: 10),
              VideoServiceTestButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
