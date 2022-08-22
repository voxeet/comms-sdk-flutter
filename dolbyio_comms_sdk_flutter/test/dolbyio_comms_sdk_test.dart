import 'dart:developer' as developer;

import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk.dart';
import 'package:dolbyio_comms_sdk_flutter/src/dolbyio_comms_sdk_flutter_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mock/dolbyio_comms_sdk_test.mocks.dart';
import 'mock/mock_event_method_channel.dart';
import 'mock/mock_extensions.dart';
import 'mock/mock_sdk_method_channel.dart';

abstract class RefreshAccessTokenCallback {
  Future<String?> call();
}

@GenerateMocks([RefreshAccessTokenCallback])
void main() {
  var sdk = DolbyioCommsSdk.instance;
  final MethodChannel channel =
      DolbyioCommsSdkFlutterPlatform.createMethodChannel("sdk");

  final mockMethodChannel = MockSdkMethodChannel();
  final mockEventEmitter = MockEventMethodChannel();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return mockMethodChannel.onMethodCall(methodCall);
    });
    mockEventEmitter.prepare();
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
    mockEventEmitter.release();
  });

  developer.log("start test");

  test("test if callback is called when native side requests token refresh",
      () async {
    final callback = MockRefreshAccessTokenCallback();
    when(callback.call()).thenAnswer((_) => Future.value("refreshToken"));

    sdk.initializeToken("accessToken", callback);
    channel.invokeMockMethod("getRefreshToken", null);

    verify(callback.call()).called(1);
  });
}
