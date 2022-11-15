import Foundation
import VoxeetSDK

class RemoteAudioServiceBinding: Binding {

    /// Enables the local participant's video and sends the video to a conference.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    public func start(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let current = VoxeetSDK.shared.conference.current
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.audio.remote.start(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
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
        do {
            let current = VoxeetSDK.shared.conference.current
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.audio.remote.stop(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
}

extension RemoteAudioServiceBinding: FlutterBinding {
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
