import Foundation

public class VideoPresentationServiceAsserts {
    
    private static var instance: VideoPresentationServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?
    
    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.VideoPresentationServiceAsserts"
        )
    }
    
    private func assertStartArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.videoPresentation.startHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.videoPresentation.startArgs
        try ifKeyExists(arg: args, key: "url") { (url: String) in
            try nativeAssertEquals(mockArgs?.absoluteString, url)
        }
    }
    
    private func assertStopArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.videoPresentation.stopHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }
    
    private func assertPlayArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.videoPresentation.playHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }
    
    private func assertPauseArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.videoPresentation.pauseHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.videoPresentation.pauseArgs
        try ifKeyExists(arg: args, key: "timestamp") { (timestamp: Int) in
            try nativeAssertEquals(mockArgs, timestamp)
        }
    }
    
    private func assertSeekArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.videoPresentation.seekHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.videoPresentation.seekArgs
        try ifKeyExists(arg: args, key: "timestamp") { (timestamp: Int) in
            try nativeAssertEquals(mockArgs, timestamp)
        }
    }
    
    private func assertStateArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.videoPresentation.state.rawValue
        try ifKeyExists(arg: args, key: "state") { (state: Int) in
            try nativeAssertEquals(mockArgs, state)
        }
    }
}

extension VideoPresentationServiceAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
                
            case "assertStartArgs":
                try assertStartArgs(args: args)
                
            case "assertStopArgs":
                try assertStopArgs(args: args)
                
            case "assertPlayArgs":
                try assertPlayArgs(args: args)
                
            case "assertPauseArgs":
                try assertPauseArgs(args: args)
                
            case "assertSeekArgs":
                try assertSeekArgs(args: args)
                
            case "assertStateArgs":
                try assertStateArgs(args: args)
                
            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

