import Foundation
import VoxeetSDK

// MARK: - Supported Events
private enum EventKeys: String, CaseIterable {
    case messageReceived = "EVENT_COMMAND_MESSAGE_RECEIVED"
}

class CommandServiceBinding: Binding {
    
    override func onInit() {
        super.onInit()
        VoxeetSDK.shared.command.delegate = self
    }
    
    /// Sends a message to all conference participants.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    public func send(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        
        do {
            let message: String = try flutterArguments.asDictionary(argKey: "message").decode()
            VoxeetSDK.shared.command.send(message: message) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
}

extension CommandServiceBinding: VTCommandDelegate {
    func received(participant: VTParticipant, message: String) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.messageReceived,
                body: DTO.MessageReceivedData(
                    message: message,
                    participant: participant
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension CommandServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "send":
            send(flutterArguments: flutterArguments, completionHandler: completionHandler)
        
        default:
            completionHandler.methodNotImplemented()
        }
    }
}

