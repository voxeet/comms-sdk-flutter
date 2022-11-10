import Foundation

public class RecordingServiceAsserts {

    private static var instance: RecordingServiceAsserts?
    public static func create() {
        instance = .init()
    }

    var methodChannel: AssertsMethodChannel?

    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.RecordingServiceAsserts"
        )
    }

    private func setCurrentRecording(args: [String: Any]) throws {
        let status = args["status"] as? Bool ?? false
        let participant = VTParticipant()
        participant.id = args["participantId"] as? String ?? ""
        let startTimestamp = args["startTimestamp"] as? Int ?? 0

		VoxeetSDK.shared.recording.delegate?.recordingStatusUpdated(
			status: status ? .recording : .notRecording,
			participant: participant,
			startTimestamp: .init(value: startTimestamp)
		)
	}

    private func assertStartRecordingArgs(args: [String:Any]) throws {
		let mockArgs = VoxeetSDK.shared.recording.startHasRun
		try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
			try nativeAssertEquals(mockArgs, hasRun)
		}
	}

    private func assertStopRecordingArgs(args: [String:Any]) throws {
		let mockArgs = VoxeetSDK.shared.recording.stopHasRun
		try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
			try nativeAssertEquals(mockArgs, hasRun)
		}
	}
}

extension RecordingServiceAsserts: SDKAsserts {

    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {

            case "setCurrentRecording":
                try setCurrentRecording(args: args)

            case "assertStartRecordingArgs":
                try assertStartRecordingArgs(args: args)

            case "assertStopRecordingArgs":
                try assertStopRecordingArgs(args: args)

            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

