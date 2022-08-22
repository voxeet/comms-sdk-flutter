import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_method_channel.dart';

void main() {
  var commandService = DolbyioCommsSdk.instance.command;
  final MethodChannel channel =  DolbyioCommsSdkFlutterPlatform.createMethodChannel("command_service");

  final mockMethodChannel = MockMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.call(methodCall.method, methodCall.arguments);
    });
  });

  tearDown(() => channel.setMockMethodCallHandler(null));

  test("test send method", () async {
    var message = "test message";
    when(channel.invokeMethod("send")).thenAnswer((_) => Future.value());

    await commandService.send(message);

    verify(channel.invokeMethod("send", {"message": message})).called(1);
  });
}
