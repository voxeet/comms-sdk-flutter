import Foundation

public class CommandServiceAsserts {
    
    private static var instance: CommandServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?

    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.CommandServiceAsserts"
        )
    }
    
    private func assertSendArgs(args: [String: Any]) throws {
        let mockSendArgs = VoxeetSDK.shared.command.sendArgs
        try ifKeyExists(arg: args, key: "message") { (message: String) in
            try nativeAssertEquals(mockSendArgs, message)
        }
    }
    
    private func emitOnMessageReceived(args: [String: Any]) throws {
        let delegate = VoxeetSDK.shared.command.delegate
        let conference = try ConferenceServiceAssertUtils.createVTConference(type: 5)
        let queue = DispatchQueue(label: "command.asserts.test.queue")
        queue.asyncAfter(deadline: .now() + 10) {
            delegate?.received(participant: conference.participants[0], message: "test")
            queue.asyncAfter(deadline: .now() + 0.5) {
                delegate?.received(participant: conference.participants[1], message: "test")
            }
        }
    }
}

extension CommandServiceAsserts: SDKAsserts {
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
            case "assertSendArgs":
                try assertSendArgs(args: args)
                
            case "emitOnMessageReceived":
                try emitOnMessageReceived(args: args)
                
            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

