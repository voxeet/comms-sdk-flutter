import Flutter
import UIKit
import VoxeetSDK

public class SwiftDolbyioCommsSdkFlutterPlugin: NSObject, FlutterPlugin {

	static var bindings: Array<Binding>?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dolbyio_comms_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftDolbyioCommsSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
		bindings = [
			SdkBinding(name: "sdk", registrar: registrar),
			ConferenceServiceBinding(name: "conference_service", registrar: registrar),
			SessionServiceBinding(name: "session_service", registrar: registrar),
			RecordingServiceBinding(name: "recording_service", registrar: registrar),
			CommandServiceBinding(name: "command_service", registrar: registrar),
			MediaDeviceServiceBinding(name: "media_device_service", registrar: registrar),
			VideoPresentationServiceBinding(name: "video_presentation_service", registrar: registrar)
		]
        
        let factory = FLVideoViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "video_view")
    }
}
