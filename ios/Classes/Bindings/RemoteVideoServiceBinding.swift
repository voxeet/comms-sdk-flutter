import Foundation
import VoxeetSDK

class RemoteVideoServiceBinding: Binding {

    /// If the local participant used the stop method to stop receiving video streams from selected remote participants,
    /// the start method allows the participant to start receiving video streams from these participants.
    /// The start method does not impact the video transmission between remote participants and a conference and does not
    /// allow the local participant to force sending remote participants’ streams to the conference or to the local participant.
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
            VoxeetSDK.shared.video.remote.start(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Allows the local participant to stop receiving video from specific remote participants.
    /// This method does not impact audio transmission between remote participants and a conference and does not allow the local
    /// participant to stop sending remote participants’ streams to the conference.
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
            VoxeetSDK.shared.video.remote.stop(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
}

extension RemoteVideoServiceBinding: FlutterBinding {
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
