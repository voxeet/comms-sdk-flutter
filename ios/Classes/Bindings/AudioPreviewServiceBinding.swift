import Foundation
import VoxeetSDK

class AudioPreviewServiceBinding: Binding {

    /// Retrieves the status.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func status(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        let status = audioPreview().status
        completionHandler.success(encodable: DTO.RecorderStatus(recorderStatus: status))
    }
    
    /// Retrieves the comfort noise level setting for output devices in Dolby Voice conferences.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func getCaptureMode(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let audioCaptureMode = audioPreview().captureMode
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
            let captureOptions = try flutterArguments
                .asSingle()
                .decode(type: DTO.AudioCaptureOptions.self)
            VoxeetSDK.shared.audio.local.preview.captureMode = try captureOptions.toSdk()
            completionHandler.success()
        } catch {
            completionHandler.failure(error)
        }
    }


    /// Plays the recorded audio preview.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func play(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let loop: Bool = try flutterArguments.asDictionary(argKey: "loop").decode()
            audioPreview().play(loop: loop) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Records an audio preview.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func record(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let duration: Int = try flutterArguments.asDictionary(argKey: "duration").decode()
            audioPreview().record(duration: duration) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }

    /// If playing or recording is underway calling this method will cancel the ongoing activity.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func cancel(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        audioPreview().cancel()
        completionHandler.success(flutterConvertible: true)
    }

    /// Release the internal memory and restart the audio session configuration.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    public func release(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        audioPreview().release()
        completionHandler.success()
    }
}

extension AudioPreviewServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "status":
            status(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getCaptureMode":
            getCaptureMode(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "setCaptureMode":
            setCaptureMode(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "play":
            play(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "record":
            record(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "cancel":
            cancel(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "release":
            release(flutterArguments: flutterArguments, completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}

private func audioPreview() -> AudioPreview {
    return VoxeetSDK.shared.audio.local.preview
}

