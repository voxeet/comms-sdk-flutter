import Foundation
import VoxeetSDK


class SessionServiceBinding: Binding {

	/// Opens a new session.
	/// - Parameters:
	///   - flutterArguments: Method arguments passed from Flutter.
	///   - completionHandler: Call methods on this instance when execution has finished.
	func open(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
	) {
        do {
            let participantInfo = try flutterArguments.asSingle().decode(type: DTO.ParticipantInfo.self)
            VoxeetSDK.shared.session.open(info: participantInfo.toSdkType()) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
	}

	/// Closes the current session.
	/// Close a session is like a logout, it will stop the socket and stop sending VoIP push notification.
	/// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
	func close(
        completionHandler: FlutterMethodCallCompletionHandler
	) {
		VoxeetSDK.shared.session.close { error in
            completionHandler.handleError(error)?.orSuccess()
		}
	}

	/// Provides current session user.
	/// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
	func getParticipant(
        completionHandler: FlutterMethodCallCompletionHandler
	) {
		if let participant = VoxeetSDK.shared.session.participant {
            completionHandler.success(encodable: DTO.Participant(participant: participant))
		} else {
            completionHandler.failure(BindingError.noCurrentParticipant)
		}
	}

	/// Checks whether there is an open session that connects SDK with backend.
	/// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
	 func isOpen(
        completionHandler: FlutterMethodCallCompletionHandler
	) {
        completionHandler.success(flutterConvertible: VoxeetSDK.shared.session.isOpen)
	}
}

extension SessionServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "open":
            open(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "close":
            close(completionHandler: completionHandler)
        case "getParticipant":
            getParticipant(completionHandler: completionHandler)
        case "isOpen":
            isOpen(completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}
