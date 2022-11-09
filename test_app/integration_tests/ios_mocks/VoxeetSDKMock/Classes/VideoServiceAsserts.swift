import Foundation

public class VideoServiceAsserts {
    
    private static var instance: VideoServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?
    
    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.VideoServiceAsserts"
        )
    }
    
    private func assertLocalStartArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.video.local.startHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }
    
    private func assertLocalStopArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.video.local.stopHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }

    private func assertRemoteStartArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.video.remote.startArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func assertRemoteStopArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.video.remote.stopArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }
}

extension VideoServiceAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
                
            case "assertLocalStartArgs":
                try assertLocalStartArgs(args: args)
                
            case "assertLocalStopArgs":
                try assertLocalStopArgs(args: args)

            case "assertRemoteStartArgs":
                try assertRemoteStartArgs(args: args)

            case "assertRemoteStopArgs":
                try assertRemoteStopArgs(args: args)

            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

