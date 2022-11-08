import Foundation
import WebRTC

@objcMembers public class RecordingService: NSObject {

    public weak var delegate: VTRecordingDelegate?

	var startHasRun: Bool = false
    var startArgs: Int?
    var startReturn: NSError?
    public func start(fireInterval: Int = 0, completion: ((_ error: NSError?) -> Void)? = nil)
    {
		startHasRun = true
        startArgs = fireInterval
        completion?(startReturn)
    }
	var stopHasRun: Bool = false
    var stopReturn: NSError?
    public func stop(completion: ((_ error: NSError?) -> Void)? = nil) {
		stopHasRun = true
        completion?(stopReturn)
    }
}

@objc public protocol VTRecordingDelegate {
    @objc func recordingStatusUpdated(status: VTRecordingStatus, participant: VTParticipant?, startTimestamp: NSNumber?)
}
