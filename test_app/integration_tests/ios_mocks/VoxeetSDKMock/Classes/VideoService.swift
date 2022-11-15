import Foundation

@objcMembers public class VideoService: NSObject {

    public var local: LocalVideo = .init()

    public var remote: RemoteVideo = .init()
}

@objcMembers public class LocalVideo : NSObject {

    var startHasRun: Bool = false
    var startReturn: NSError?
    public func start(completion: ((_ error: Error?) -> Void)?) {
        startHasRun = true
        completion?(startReturn)
    }

    var stopHasRun: Bool = false
    var stopReturn: NSError?
    public func stop(completion: ((_ error: Error?) -> Void)?) {
        stopHasRun = true
        completion?(stopReturn)
    }
}

@objcMembers public class RemoteVideo : NSObject {

    var startArgs: VTParticipant?
    var startReturn: NSError?
    public func start(participant: VTParticipant, completion: ((_ error: NSError?) -> Void)?) {
        startArgs = participant
        completion?(startReturn)
    }

    var stopArgs: VTParticipant?
    var stopReturn: NSError?
    public func stop(participant: VTParticipant, completion: ((_ error: NSError?) -> Void)?) {
        stopArgs = participant
        completion?(stopReturn)
    }
}
