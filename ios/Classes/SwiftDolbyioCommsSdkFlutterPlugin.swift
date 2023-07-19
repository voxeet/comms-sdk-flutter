import Flutter
import UIKit
import VoxeetSDK

public class SwiftDolbyioCommsSdkFlutterPlugin: NSObject, FlutterPlugin {

	static var bindings: Array<Binding>?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dolbyio_comms_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftDolbyioCommsSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        VoxeetSDK.shared._registerComponentVersion(
            name: PluginInfo.componentName, 
            version: PluginInfo.sdkVersion
        )

		bindings = [
			SdkBinding(name: "sdk", registrar: registrar),
			ConferenceServiceBinding(name: "conference_service", registrar: registrar),
			SessionServiceBinding(name: "session_service", registrar: registrar),
			RecordingServiceBinding(name: "recording_service", registrar: registrar),
			CommandServiceBinding(name: "command_service", registrar: registrar),
			MediaDeviceServiceBinding(name: "media_device_service", registrar: registrar),
			VideoPresentationServiceBinding(name: "video_presentation_service", registrar: registrar),
			NotificationServiceBinding(name: "notification_service", registrar: registrar),
			FilePresentationServiceBinding(name: "file_presentation_service", registrar: registrar),
			LocalAudioServiceBinding(name: "local_audio", registrar: registrar),
			RemoteAudioServiceBinding(name: "remote_audio", registrar: registrar),
			LocalVideoServiceBinding(name: "local_video", registrar: registrar),
			RemoteVideoServiceBinding(name: "remote_video", registrar: registrar),
            AudioPreviewServiceBinding(name: "audio_preview", registrar: registrar)
		]
        
        let factory = FLVideoViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "video_view")
    }
}
