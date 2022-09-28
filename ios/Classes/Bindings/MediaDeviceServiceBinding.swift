import Foundation
import VoxeetSDK

class MediaDeviceServiceBinding: Binding {

	/// Retrieves the comfort noise level setting for output devices in Dolby Voice conferences.
	/// - Parameters:
	///   - flutterArguments: Method arguments passed from Flutter.
	///   - completionHandler: Call methods on this instance when execution has finished.
	func getComfortNoiseLevel(
		flutterArguments: FlutterMethodCallArguments,
		completionHandler: FlutterMethodCallCompletionHandler
	) {
		VoxeetSDK.shared.mediaDevice.getComfortNoiseLevel { comfortNoise, error in
			if let error = error {
				completionHandler.failure(error)
			} else {
				completionHandler.success(encodable: DTO.ComfortNoiseLevel(noiseLevel: comfortNoise))
			}
		}
	}

	/// Sets the comfort noise level for output devices in Dolby Voice conferences.
	/// - Parameters:
	///   - flutterArguments: Method arguments passed from Flutter.
	///   - completionHandler: Call methods on this instance when execution has finished.
	func setComfortNoiseLevel(
		flutterArguments: FlutterMethodCallArguments,
		completionHandler: FlutterMethodCallCompletionHandler
	) {
		do {
			let noiseLevel = try flutterArguments.asDictionary(argKey: "noiseLevel").decode(type: DTO.ComfortNoiseLevel.self)
			VoxeetSDK.shared.mediaDevice.setComfortNoiseLevel(comfortNoise: noiseLevel.toSdkType()) { error in
				completionHandler.handleError(error)?.orSuccess()
			}
		} catch {
			completionHandler.failure(error)
		}
	}

	/// Checks whether an application uses the front-facing (true) or back-facing camera (false).
	/// - Parameters:
	///   - flutterArguments: Method arguments passed from Flutter.
	///   - completionHandler: Call methods on this instance when execution has finished.
	func isFrontCamera(
		flutterArguments: FlutterMethodCallArguments,
		completionHandler: FlutterMethodCallCompletionHandler
	) {
		completionHandler.success(encodable: VoxeetSDK.shared.mediaDevice.isFrontCamera)
	}

	/// Switches the current camera to a different camera that is available.
	/// - Parameters:
	///   - flutterArguments: Method arguments passed from Flutter.
	///   - completionHandler: Call methods on this instance when execution has finished.
	func switchCamera(
		flutterArguments: FlutterMethodCallArguments,
		completionHandler: FlutterMethodCallCompletionHandler
	) {
		VoxeetSDK.shared.mediaDevice.switchCamera {
			completionHandler.success()
		}
	}

	/// Switches the current speaker to a different speaker that is available.
	/// - Parameters:
	///   - flutterArguments: Method arguments passed from Flutter.
	///   - completionHandler: Call methods on this instance when execution has finished.
	func switchSpeaker(
		flutterArguments: FlutterMethodCallArguments,
		completionHandler: FlutterMethodCallCompletionHandler
	) {
		VoxeetSDK.shared.mediaDevice.switchDeviceSpeaker()
		completionHandler.success()
	}
}

extension MediaDeviceServiceBinding: FlutterBinding {
	func handle(
		methodName: String,
		flutterArguments: FlutterMethodCallArguments,
		completionHandler: FlutterMethodCallCompletionHandler
	) {
		switch methodName {
		case "getComfortNoiseLevel":
			getComfortNoiseLevel(flutterArguments: flutterArguments, completionHandler: completionHandler)
		case "isFrontCamera":
			isFrontCamera(flutterArguments: flutterArguments, completionHandler: completionHandler)
		case "setComfortNoiseLevel":
			setComfortNoiseLevel(flutterArguments: flutterArguments, completionHandler: completionHandler)
		case "switchCamera":
			switchCamera(flutterArguments: flutterArguments, completionHandler: completionHandler)
		case "switchSpeaker":
			switchSpeaker(flutterArguments: flutterArguments, completionHandler: completionHandler)
		default:
			completionHandler.methodNotImplemented()
		}
	}
}
