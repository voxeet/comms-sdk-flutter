import Foundation
import VoxeetSDK

// MARK: - Supported Events
private enum EventKeys: String, CaseIterable {
    /// Emitted when a video presentation is paused.
    case paused = "EVENT_VIDEOPRESENTATION_PAUSED"
    /// Emitted when a video presentation is resumed.
    case played = "EVENT_VIDEOPRESENTATION_PLAYED"
    /// Emitted when a video presentation is sought.
    case sought = "EVENT_VIDEOPRESENTATION_SOUGHT"
    /// Emitted when a video presentation is started.
    case started = "EVENT_VIDEOPRESENTATION_STARTED"
    /// Emitted when a video presentation is stopped.
    case stopped = "EVENT_VIDEOPRESENTATION_STOPPED"
}

class VideoPresentationServiceBinding: Binding {
    
    /// Returns information about the current video presentation.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func currentVideo(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        guard let currentVideo = VoxeetSDK.shared.videoPresentation.current else {
            completionHandler.success()
            return
        }
        completionHandler.success(encodable: DTO.VideoPresentation(videoPresentation: currentVideo))
    }
    
    /// Starts a video presentation.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func start(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            guard let url: URL = .init(string: try flutterArguments.asDictionary(argKey: "url").decode()) else {
                throw BindingError.noUrlProvided
            }
            VoxeetSDK.shared.videoPresentation.start(url: url) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Stops a video presentation.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func stop(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.videoPresentation.stop() { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
    
    /// Resumes the paused video.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func play(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.videoPresentation.play() { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
    
    /// Pauses a video presentation at a certain timestamp, in milliseconds.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func pause(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let timestamp: Int = try flutterArguments.asDictionary(argKey: "timestamp").decode() ?? 0
            VoxeetSDK.shared.videoPresentation.pause(timestamp: timestamp) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Allows a presenter to navigate to a specific section of the shared video file.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func seek(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let timestamp: Int = try flutterArguments.asDictionary(argKey: "timestamp").decode() ?? 0
            VoxeetSDK.shared.videoPresentation.seek(timestamp: timestamp) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Provides the current state of a video presentation.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func state(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        completionHandler.success(encodable: DTO.VideoPresentationState(state: VoxeetSDK.shared.videoPresentation.state))
    }
}

extension VideoPresentationServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "currentVideo":
            currentVideo(completionHandler: completionHandler)
        case "start":
            start(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "stop":
            stop(completionHandler: completionHandler)
        case "play":
            play(completionHandler: completionHandler)
        case "pause":
            pause(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "seek":
            seek(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "state":
            state(completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}

extension VideoPresentationServiceBinding: VTVideoPresentationDelegate {
    
    public func started(videoPresentation: VTVideoPresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.started,
                body: DTO.VideoPresentation(videoPresentation: videoPresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func stopped(videoPresentation: VTVideoPresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.stopped,
                body: DTO.VideoPresentation(videoPresentation: videoPresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func played(videoPresentation: VTVideoPresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.played,
                body: DTO.VideoPresentation(videoPresentation: videoPresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func paused(videoPresentation: VTVideoPresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.paused,
                body: DTO.VideoPresentation(videoPresentation: videoPresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func sought(videoPresentation: VTVideoPresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.sought,
                body: DTO.VideoPresentation(videoPresentation: videoPresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
