import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const voxeetSDKAsertsMethodChannel = MethodChannel('IntegrationTesting.VoxeetSDKAsserts');
const sessionServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.SessionServiceAsserts');
const conferenceServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.ConferenceServiceAsserts');
const recordingServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.RecordingServiceAsserts');
const commandServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.CommandServiceAsserts');
const mediaDeviceServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.MediaDeviceServiceAsserts');
const videoPresentationServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.VideoPresentationServiceAsserts');
const notificationServiceAssertsMethodChannel = MethodChannel('IntegrationTesting.NotificationServiceAsserts');

void _handleNativeResult(List<dynamic> invokeMethodResult, String messagePrefix, String label) {
  if (invokeMethodResult[0] == false) {
    var actualValue = invokeMethodResult[1];
    var expectedValue = invokeMethodResult[2];
    var problem = "unknown";
    if (invokeMethodResult[3] != null) {
      problem = invokeMethodResult[3];
    }

    var location = "unknown";
    if (
      invokeMethodResult[4] != null &&
      invokeMethodResult[5] != null &&
      invokeMethodResult[6] != null
    ) {
      location = "\n\t\tfile ${invokeMethodResult[4]} \n\t\tfunction ${invokeMethodResult[5]} \n\t\tline ${invokeMethodResult[6]}";
    }
    if (actualValue != null && expectedValue != null) {
      fail("$messagePrefix: \n\tLabel: $label \n\tExpected value: $expectedValue \n\tActual value: $actualValue \n\tProblem: $problem \n\tLocation $location");
    } else {
      fail("$messagePrefix: \n\tLabel: $label \n\tProblem: $problem \n\tLocation $location");
    }
  }
}

Future<void> expectNative({
  required MethodChannel methodChannel,
  required String assertLabel,
  required dynamic expected
}) async {
  _handleNativeResult(
    await methodChannel.invokeMethod(assertLabel, expected), 
    "Expect native", 
    assertLabel);
  return Future<void>.value();
}

Future<void> runNative({
  required MethodChannel methodChannel,
  required String label,
  dynamic args
}) async {
  _handleNativeResult(
    await methodChannel.invokeMethod(label, args), 
    "Run native", 
    label);
  return Future<void>.value();
}

Future<void> resetSDK() async {
  return await runNative(methodChannel: voxeetSDKAsertsMethodChannel, label: "resetVoxeetSDK");
}
