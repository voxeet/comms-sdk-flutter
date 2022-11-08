import Foundation

public class SessionServiceAsserts {
    
    private static var instance: SessionServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?

    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.SessionServiceAsserts"
        )
    }
    
    private func assertCloseArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.session.closeHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockArgs, hasRun)
        }
    }

    private func setLocalParticipant(args: [String: Any]) throws {
        try VoxeetSDK.shared.session.participant = try ConferenceServiceAssertUtils.createVTParticipant(args: args)
    }
}

extension SessionServiceAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
            
            case "assertCloseArgs":
                try assertCloseArgs(args: args)
                
            case "setLocalParticipantArgs":
                try setLocalParticipant(args: args)

            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

