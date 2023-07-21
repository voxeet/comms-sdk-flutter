import UIKit
import Flutter
import VoxeetSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private var testChannel: FlutterMethodChannel? = nil
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
#if USE_SDK_MOCK
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        assertsMethodChannelFactory = AssertsMethodChannelFactoryImpl(
            binaryMessenger: controller.binaryMessenger
        )
        
        VoxeetSDKAsserts.create()
        SessionServiceAsserts.create()
        ConferenceServiceAsserts.create()
        RecordingServiceAsserts.create()
        CommandServiceAsserts.create()
        MediaDeviceServiceAsserts.create()
        VideoPresentationServiceAsserts.create()
        NotificationServiceAsserts.create()
        FilePresentationServiceAsserts.create()
        VideoServiceAsserts.create()
        AudioServiceAsserts.create()
        AudioPreviewAsserts.create()
#endif
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

#if USE_SDK_MOCK

class AssertsMethodChannelImpl: AssertsMethodChannel {
    
    weak var delegate: AssertsMethodChannelDelegate?
    
    let flutterMethodChannel: FlutterMethodChannel
    
    init(channelName: String, binaryMessanger: FlutterBinaryMessenger) {
        flutterMethodChannel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: binaryMessanger
        )
        flutterMethodChannel.setMethodCallHandler { [weak self] call, result in
            self?.delegate?.runAssert(
                call.method,
                args: call.arguments as? [String: Any] ?? [String: Any](),
                result: { sdkAsertResult in
                    switch sdkAsertResult {
                    case .success:
                        result([NSNumber(value: true), ""])
                    case let .failure(error):
                        switch error {
                        case let .failure(
                            actualValue, expectedValue, msg, fileName, functionName, lineNumber
                        ):
                            result([
                                NSNumber(value: false),
                                actualValue, expectedValue,
                                msg,
                                fileName, functionName, lineNumber
                            ])
                        case let .failureWithoutValue(
                            msg, fileName, functionName, lineNumber
                        ):
                            result([
                                NSNumber(value: false),
                                nil, nil,
                                msg,
                                fileName, functionName, lineNumber
                            ])
                        case .unknownAssert:
                            result(FlutterMethodNotImplemented)
                        }
                        
                    }
                }
            )
        }
    }
}

class AssertsMethodChannelFactoryImpl: AssertsMethodChannelFactory {
    
    let binaryMessenger: FlutterBinaryMessenger
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }
    
    func createAssertMethodChannel(
        delegate: AssertsMethodChannelDelegate,
        channelName: String) -> AssertsMethodChannel
    {
        let methodChannel = AssertsMethodChannelImpl(channelName: channelName, binaryMessanger: binaryMessenger)
        methodChannel.delegate = delegate
        return methodChannel
    }
}

#endif
