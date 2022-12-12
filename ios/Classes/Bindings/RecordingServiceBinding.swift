import Foundation
import VoxeetSDK

private enum EventKeys: String, CaseIterable {
    /// Emitted when the recording state of the conference is updated from the remote location.
    case recordingStatusUpdate = "EVENT_RECORDING_STATUS_UPDATED"
}

class RecordingServiceBinding: Binding {

    override func onInit() {
        super.onInit()
        VoxeetSDK.shared.recording.delegate = self
    }

    private var currentRecording: DTO.RecordingInformation = .init(
        participantId: nil,
        startTimestamp: nil,
        recordingStatus: .init(recordingStatus: .notRecording)
    )
    
    /// Provides the current recording.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func currentRecording(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        completionHandler.success(encodable: currentRecording)
    }

    /// Starts recording a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func start(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.recording.start() { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }

    /// Stops recording a conference.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func stop(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.recording.stop() { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
}

extension RecordingServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "currentRecording":
            currentRecording(completionHandler: completionHandler)
        case "start":
            start(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "stop":
            stop(completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}

extension RecordingServiceBinding: VTRecordingDelegate {
    func recordingStatusUpdated(
        status: VTRecordingStatus,
        participant: VTParticipant?,
        startTimestamp: NSNumber?
    ) {
        currentRecording = .init(
            participantId: participant?.id,
            startTimestamp: startTimestamp?.intValue,
            recordingStatus: .init(recordingStatus: status)
        )

        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.recordingStatusUpdate,
                body: DTO.RecordingStatusUpdateNotification(
                    recordingInformation: currentRecording,
                    conferenceId: VoxeetSDK.shared.conference.current?.id
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
