import Foundation

public class VoxeetSDKAsserts {
    
    private static var instance: VoxeetSDKAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?

    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.VoxeetSDKAsserts"
        )
    }
    
    private func resetVoxeetSDK() {
        let oldSDK = VoxeetSDK.shared
        VoxeetSDK.shared = VoxeetSDK()
        VoxeetSDK.shared.recording.delegate = oldSDK.recording.delegate
        VoxeetSDK.shared.audio.local.preview.onStatusChanged
            = oldSDK.audio.local.preview.onStatusChanged
    }
    
    private func assertInitializeConsumerKeyAndSecret(args: [String: Any]) throws {
        let initializeArgs = VoxeetSDK.shared.initializeArgs
        try nativeAssertEquals(
            initializeArgs?.consumerKey,
            args["consumerKey"] as? String,
            msg: "Incorrect consumerKey"
        )
        try nativeAssertEquals(
            initializeArgs?.consumerSecret,
            args["consumerSecret"] as? String,
            msg: "Incorect consumerSecret"
        )
    }

    private func assertInitializeToken(args: [String: Any]) throws {
        let initializeWithTokenArgs = VoxeetSDK.shared.initializeWithTokenArgs
        try nativeAssertEquals(
            initializeWithTokenArgs?.accessToken,
            args["accessToken"] as? String,
            msg: "Incorrect accessToken"
        )
    }
}

extension VoxeetSDKAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
                
            case "resetVoxeetSDK":
                resetVoxeetSDK()
                
            case "assertInitializeConsumerKeyAndSecret":
                try assertInitializeConsumerKeyAndSecret(args: args)
                
            case "assertInitializeToken":
                try assertInitializeToken(args: args)

            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}
