import Foundation
import VoxeetSDK

class LocalVideoServiceBinding: Binding {

    /// Enables the local participant's video and sends the video to a conference.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    public func start(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.video.local.start { error in
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
        VoxeetSDK.shared.video.local.stop { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
}

extension LocalVideoServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {

        case "start":
            start(flutterArguments: flutterArguments, completionHandler: completionHandler)

        case "stop":
            stop(flutterArguments: flutterArguments, completionHandler: completionHandler)

        default:
            completionHandler.methodNotImplemented()
        }
    }
}
