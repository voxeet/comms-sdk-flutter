import Foundation

public class MediaDeviceServiceAsserts {

	private static var instance: MediaDeviceServiceAsserts?
	public static func create() {
		instance = .init()
	}

	var methodChannel: AssertsMethodChannel?

	public init() {
		assertsMethodChannelFactory.createAssertMethodChannel(
			forSdkAsserts: self,
			channelName: "IntegrationTesting.MediaDeviceServiceAsserts"
		)
	}

	private func assertGetComfortNoiseLevelArgs(args: [String: Any]) throws {
		let mockHasRun = VoxeetSDK.shared.mediaDevice.getComfortNoiseHasRun
		try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
			try nativeAssertEquals(mockHasRun, hasRun)
		}
		let mockArgs = VoxeetSDK.shared.mediaDevice.noiseLevel
		try ifKeyExists(arg: args, key: "noiseLevel") { (noiseLevel: Int) in
			try nativeAssertEquals(mockArgs.rawValue, noiseLevel)
		}
	}

	private func assertSetComfortNoiseLevelArgs(args: [String: Any]) throws {
		let mockArgs = VoxeetSDK.shared.mediaDevice.setComfortNoiseLevelArgs
		try ifKeyExists(arg: args, key: "noiseLevel") { (noiseLevel: Int) in
			try nativeAssertEquals(mockArgs?.rawValue, noiseLevel)
		}
	}

	private func assertSwitchCameraArgs(args: [String: Any]) throws {
		let mockArgs = VoxeetSDK.shared.mediaDevice.switchCameraHasRun
		try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
			try nativeAssertEquals(mockArgs, hasRun)
		}
	}

	private func assertSwitchDeviceSpeakerArgs(args: [String: Any]) throws {
		let mockArgs = VoxeetSDK.shared.mediaDevice.switchDeviceSpeakerHasRun
		try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
			try nativeAssertEquals(mockArgs, hasRun)
		}
	}
}

extension MediaDeviceServiceAsserts: SDKAsserts {

	public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
		do {
			switch assert {

			case "assertGetComfortNoiseLevelArgs":
				try assertGetComfortNoiseLevelArgs(args: args)
			case "assertSetComfortNoiseLevelArgs":
				try assertSetComfortNoiseLevelArgs(args: args)
			case "assertSwitchCameraArgs":
				try assertSwitchCameraArgs(args: args)
			case "assertSwitchDeviceSpeakerArgs":
				try assertSwitchDeviceSpeakerArgs(args: args)

			default:
				throw SDKAssertError.unknownAssert
			}
			result(.success(()))
		} catch {
			result(SDKAssertError.toResult(error: error))
		}
	}
}

