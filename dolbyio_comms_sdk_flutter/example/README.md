# Example application for the Dolby.io Communications SDK for Flutter

The example application helps to test and develop the dolbyio_comms_sdk_flutter plugin.

## Get started

### Prerequisites

This project uses the Flutter SDK and requires a basic knowledge of Flutter. If you need help with 
Flutter development, see the [Flutter documentation](https://docs.flutter.dev).

Make sure that you have:
* A [Dolby.io](https://dolby.io) account. If you do not have an account, you can [sign up](https://dolby.io/signup) for a 
  free account.
* An iOS or Android device, or a device emulator
* Flutter SDK 3.0.3 or later configured to work on iOS and Android. For more information, see the
  [installation documentation for flutter][flutter_intalation] guide.
* Android Studio for Android development
* Xcode and CocoaPods for iOS development

### Get the client access token

To obtain the [client access token][client_access_token] from the [Dolby.io dashboard][dolby.io_dashboard], follow these steps:

1. Log in to the [Dolby.io dashboard](https://dashboard.dolby.io/). 

2. Create an application.

3. Navigate to the **API keys** section.

4. Find the following code in the`dolbyio_comms_sdk_flutter/example/lib/example_app_rn/login_screen_rn.dart` file:

```
  @override
  void initState() {
    super.initState();
    // accessToken = ''; SET YOUR ACCESS TOKEN HERE
    initSessionStatus();
  }
```

5. Uncomment the line where `accessToken` is mentioned and paste the copied token between the quotation marks.

## Run the application

1. Make sure that your device is available:
```
flutter devices
```

2. Go to the **example** directory:
```
cd dolbyio_comms_sdk_flutter/example
```

3. Run the application:
```
flutter run
```

4. Tap the **Open example app** button and join a conference.

[flutter_intalation]: https://docs.flutter.dev/get-started/install
[client_access_token]: https://docs.dolby.io/communications-apis/docs/overview-developer-tools#client-access-token
[dolby.io_dashboard]: https://dashboard.dolby.io/
