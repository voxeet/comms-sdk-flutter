import Foundation
import VoxeetSDK

class LocalAudioServiceBinding: Binding {

    /// Retrieves the comfort noise level setting for output devices in Dolby Voice conferences.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func getCaptureMode(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            guard let audioCaptureMode = VoxeetSDK.shared.audio.local.captureMode else {
                completionHandler.success()
                return
            }
            completionHandler.success(encodable: try DTO.AudioCaptureOptions(audioCaptureMode: audioCaptureMode))
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Sets the comfort noise level for output devices in Dolby Voice conferences.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func setCaptureMode(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let captureOptions = try flutterArguments.asSingle().decode(type: DTO.AudioCaptureOptions.self)
            VoxeetSDK.shared.audio.local.captureMode = try captureOptions.toSdk()
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Retrieves the comfort noise level setting for output devices in Dolby Voice conferences.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func getComfortNoiseLevel(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.audio.local.getComfortNoiseLevel { comfortNoise, error in
            if let error = error {
                completionHandler.failure(error)
            } else {
                if let comfortNoise = comfortNoise {
                    completionHandler.success(encodable: DTO.ComfortNoiseLevel(noiseLevel: comfortNoise))
                } else {
                    completionHandler.success()
                }
            }
        }
    }

    /// Sets the comfort noise level for output devices in Dolby Voice conferences.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func setComfortNoiseLevel(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let noiseLevel = try flutterArguments.asDictionary(argKey: "noiseLevel").decode(type: DTO.ComfortNoiseLevel.self)
            VoxeetSDK.shared.audio.local.setComfortNoiseLevel(noiseLevel.toSdkType()) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Enables the local participant's audio and sends the audio to a conference.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    public func start(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.audio.local.start  { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }

    /// Disables the local participant's video and stops sending the video to a conference.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    public func stop(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.audio.local.stop  { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
}

extension LocalAudioServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "getCaptureMode":
            getCaptureMode(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "setCaptureMode":
            setCaptureMode(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "getComfortNoiseLevel":
            getComfortNoiseLevel(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "setComfortNoiseLevel":
            setComfortNoiseLevel(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "start":
            start(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "stop":
            stop(flutterArguments: flutterArguments, completionHandler: completionHandler)

        default:
            completionHandler.methodNotImplemented()
        }
    }
}
