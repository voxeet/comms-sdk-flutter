import Foundation

public class AudioServiceAsserts {
    
    private static var instance: AudioServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?
    
    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.AudioServiceAsserts"
        )
    }
    
    private func assertLocalStartArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.audio.local.startHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }
    
    private func assertLocalStopArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.audio.local.stopHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }

    private func assertRemoteStartArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.audio.remote.startArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func assertRemoteStopArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.audio.remote.stopArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func assertGetComfortNoiseLevelArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.audio.local.getComfortNoiseHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        let mockArgs = VoxeetSDK.shared.audio.local.noiseLevel
        try ifKeyExists(arg: args, key: "noiseLevel") { (noiseLevel: Int) in
            try nativeAssertEquals(mockArgs.rawValue, noiseLevel)
        }
    }

    private func assertSetComfortNoiseLevelArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.audio.local.setComfortNoiseLevelArgs
        try ifKeyExists(arg: args, key: "noiseLevel") { (noiseLevel: Int) in
            try nativeAssertEquals(mockArgs?.rawValue, noiseLevel)
        }
    }
}

extension AudioServiceAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
                
            case "assertLocalStartArgs":
                try assertLocalStartArgs(args: args)
                
            case "assertLocalStopArgs":
                try assertLocalStopArgs(args: args)

            case "assertGetComfortNoiseLevelArgs":
                try assertGetComfortNoiseLevelArgs(args: args)
                
            case "assertSetComfortNoiseLevelArgs":
                try assertSetComfortNoiseLevelArgs(args: args)

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

