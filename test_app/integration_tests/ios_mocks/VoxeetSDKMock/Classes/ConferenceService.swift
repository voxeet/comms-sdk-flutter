import Foundation
import WebRTC

@objcMembers public class ConferenceService: NSObject {
    
    public weak var delegate: VTConferenceDelegate?
    
    public var defaultVideo: Bool = false
    
    public internal(set) var current: VTConference?
    
    var maxVideoForwardingReturn: Int?
    public var maxVideoForwarding: Int {
        return maxVideoForwardingReturn!
    }
    
    var createArgs: VTConferenceOptions?
    var createReturn: Any?
    public func create(options: VTConferenceOptions? = nil, success: ((_ conference: VTConference) -> Void)?, fail: ((_ error: NSError) -> Void)?) {
        createArgs = options
        
        switch createReturn {
        case let conference as VTConference: success?(conference)
        case let error as NSError: fail?(error)
        default: fatalError("ConferenceService.create: Unsuitable method return")
        }
    }
    
    var joinArgs: (conference: VTConference, options: VTJoinOptions?)?
    var joinReturn: Any?
    public func join(conference: VTConference, options: VTJoinOptions? = nil, success: ((_ conference: VTConference) -> Void)? = nil, fail: ((_ error: NSError) -> Void)? = nil) {
        joinArgs = (conference: conference, options: options)
        switch joinReturn {
        case let error as NSError: fail?(error)
        case let conference as VTConference: success?(conference)
        default: fatalError("ConferenceService.join mock: Unkown return type")
        }
        
    }
    
    var listenArgs: (conference: VTConference, options: VTListenOptions?)?
    var listenReturn: Any?
    public func listen(conference: VTConference, options: VTListenOptions? = nil, success: ((_ conference: VTConference) -> Void)? = nil, fail: ((_ error: NSError) -> Void)? = nil) {
        listenArgs = (conference: conference, options: options)
        switch listenReturn {
        case let error as NSError: fail?(error)
        case let conference as VTConference: success?(conference)
        default: fatalError("ConferenceService.listen mock: Unknown return type")
        }
    }
    
    public func demo(spatialAudio: Bool = false, completion: ((_ error: NSError?) -> Void)? = nil) {
        fatalError("Mock method not implemented")
    }
    
    var fetchArgs: String?
    var fetchReturn: VTConference?
    public func fetch(conferenceID: String, completion: (VTConference) -> Void) {
        fetchArgs = conferenceID
        completion(fetchReturn!)
    }
    
    var leaveHasRun: Bool = false
    var leaveReturn: NSError?
    public func leave(completion: ((_ error: NSError?) -> Void)? = nil) {
        leaveHasRun = true
        completion?(leaveReturn)
    }
    
    public func status(conference: VTConference, success: ((_ json: [String: Any]?) -> Void)?, fail: ((_ error: NSError) -> Void)?) {
        fatalError("Mock method not implemented")
    }
    
    var replayArgs: (conference: VTConference, replayOptions: VTReplayOptions?)?
    var replayReturn: NSError?
    public func replay(conference: VTConference, options: VTReplayOptions? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        replayArgs = (conference, options)
        completion?(replayReturn)
    }
    
    public func mute(_ isMuted: Bool, completion: ((_ error: NSError?) -> Void)? = nil) {
        fatalError("Mock method not implemented")
    }
    
    var muteArgs: (participant: VTParticipant?, isMuted: Bool)?
    var muteReturn: NSError?
    public func mute(participant: VTParticipant, isMuted: Bool, completion: ((_ error: NSError?) -> Void)? = nil) {
        muteArgs = (participant: participant, isMuted: isMuted)
        completion?(muteReturn)
    }
    
    var isMutedReturn: Bool = false
    public func isMuted() -> Bool {
        return isMutedReturn
    }
    
    var muteOutputArgs: Bool = false
    var muteOutputReturn: NSError?
    public func muteOutput(_ isMuted: Bool, completion: ((_ error: NSError?) -> Void)? = nil) {
        muteOutputArgs = isMuted
        completion?(muteOutputReturn)
    }
    
    var audioLevelArgs: VTParticipant?
    var audioLevelReturn: Float?
    public func audioLevel(participant: VTParticipant) -> Float {
        audioLevelArgs = participant
        return audioLevelReturn!
    }
    
    var speakingArgs: VTParticipant?
    var speakingReturn: Bool = false
    public func isSpeaking(participant: VTParticipant) -> Bool {
        speakingArgs = participant
        return speakingReturn
    }
    
    var startAudioArgs: VTParticipant?
    var startAudioReturn: NSError?
    public func startAudio(participant: VTParticipant? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        startAudioArgs = participant
        completion?(startAudioReturn)
    }
    
    var stopAudioArgs: VTParticipant?
    var stopAudioReturn: NSError?
    public func stopAudio(participant: VTParticipant? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        stopAudioArgs = participant
        completion?(stopAudioReturn)
    }
    
    var startVideoArgs: VTParticipant?
    var startVideoReturn: NSError?
    public func startVideo(participant: VTParticipant? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        startVideoArgs = participant
        completion?(startVideoReturn)
    }
    
    public func startVideo(participant: VTParticipant? = nil, isDefaultFrontFacing: Bool, completion: ((_ error: NSError?) -> Void)? = nil) {
        fatalError("Mock method not implemented")
    }
    
    var stopVideoArgs: VTParticipant?
    var stopVideoReturn: NSError?
    public func stopVideo(participant: VTParticipant? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        stopVideoArgs = participant
        completion?(stopVideoReturn)
    }

    var startScreenShareArgs: Bool?
    var startScreenShareReturn: NSError?
    public func startScreenShare(broadcast: Bool, completion: ((_ error: NSError?) -> Void)? = nil) {
        startScreenShareArgs = broadcast
        completion?(startScreenShareReturn)
    }

    var stopScreenShareReturn: NSError?
    public func stopScreenShare(completion: ((_ error: NSError?) -> Void)? = nil) {
        completion?(stopScreenShareReturn)
    }
    
    var kickArgs: VTParticipant?
    var kickReturn: NSError?
    public func kick(participant: VTParticipant, completion: ((_ error: NSError?) -> Void)? = nil) {
        kickArgs = participant
        completion?(kickReturn)
    }

    var spatialPositionArgs: (participant: VTParticipant?, position: VTSpatialPosition?)?
    var spatialPositionReturn: NSError?
    public func setSpatialPosition(participant: VTParticipant, position: VTSpatialPosition, completion: ((_ error: NSError?) -> Void)? = nil) {
        spatialPositionArgs = (participant, position)
        completion?(spatialPositionReturn)
    }

    var spatialDirectionArgs: (participant: VTParticipant?, direction: VTSpatialDirection?)?
    var spatialDirectionReturn: NSError?
    public func setSpatialDirection(participant: VTParticipant, direction: VTSpatialDirection, completion: ((_ error: NSError?) -> Void)? = nil) {
        spatialDirectionArgs = (participant, direction)
        completion?(spatialDirectionReturn)
    }

    var spatialEnvironmentArgs: (
        scale: VTSpatialScale?,
        forward: VTSpatialPosition?,
        up: VTSpatialPosition?,
        right: VTSpatialPosition?
    )?
    var spatialEnvironmentReturn: NSError?
    public func setSpatialEnvironment(scale: VTSpatialScale, forward: VTSpatialPosition, up: VTSpatialPosition, right: VTSpatialPosition, completion: ((_ error: NSError?) -> Void)? = nil) {
        spatialEnvironmentArgs = (scale, forward, up, right)
        completion?(spatialEnvironmentReturn)
    }

    var videoForwardingArgs: (max: Int, participants: [VTParticipant]?)?
    var videoForwardingReturn: NSError?
    public func videoForwarding(max: Int, participants: [VTParticipant]? = nil, completion: ((_ error: NSError?) -> Void)? = nil) {
        videoForwardingArgs = (max, participants)
        completion?(videoForwardingReturn)
    }
    
    var setVideoForwardingArgs: VideoForwardingOptions?
    var setVideoForwardingReturn: NSError?
    public func setVideoForwarding(options: VideoForwardingOptions, completion: ((_ error: NSError?) -> Void)? = nil) {
        setVideoForwardingArgs = options
        completion?(setVideoForwardingReturn)
    }
    
    var audioProcessingArgs: Bool?
    public func audioProcessing(enable: Bool) {
        audioProcessingArgs = enable
    }
    
    var updatePermissionsArgs: [VTParticipantPermissions]?
    var updatePermissionsReturn: NSError?
    public func updatePermissions(participantPermissions: [VTParticipantPermissions], completion: ((_ error: NSError?) -> Void)? = nil) {
        updatePermissionsArgs = participantPermissions
        completion?(updatePermissionsReturn)
    }

    var localStatsReturn: [String: [[String: Any]]]?
    public func localStats() -> [String: [[String: Any]]]? {
        return localStatsReturn
    }
}

@objc public protocol VTConferenceDelegate {
    @objc func statusUpdated(status: VTConferenceStatus)
    @objc func permissionsUpdated(permissions: [Int])
    @objc func participantAdded(participant: VTParticipant)
    @objc func participantUpdated(participant: VTParticipant)
    @objc func streamAdded(participant: VTParticipant, stream: MediaStream)
    @objc func streamUpdated(participant: VTParticipant, stream: MediaStream)
    @objc func streamRemoved(participant: VTParticipant, stream: MediaStream)
}

@objcMembers public class VTConferenceOptions: NSObject {
    public var alias: String?
    public internal(set) var params = VTConferenceParameters()
    public var pinCode: NSNumber?
    public var spatialAudioStyle: SpatialAudioStyle?
}

@objcMembers public class VTJoinOptions: NSObject {
    public var constraints = VTJoinOptionsConstraints()
    public var maxVideoForwarding: NSNumber?
    public var conferenceAccessToken: String?
    public var spatialAudio: Bool = false
}

@objcMembers public class VTJoinOptionsConstraints: NSObject {
    public var audio: Bool = true
    public var video: Bool = false
}

@objcMembers public class VTListenOptions: NSObject {
    public var maxVideoForwarding: NSNumber?
    public var conferenceAccessToken: String?
    public var spatialAudio: Bool = false
}

@objcMembers public class VideoForwardingOptions: NSObject {
    /// The strategy that defines how the SDK should select conference participants whose videos will be transmitted to the local participant.
    /// The selection can be either based on the participants' audio volume or the distance from the local participant.
    public var strategy: VideoForwardingStrategy?
    /// The maximum number of video streams that may be transmitted to the local participant.
    /// The valid values are between 0 and 4. The default value is 4. In the case of providing a value smaller than 0 or greater than 4, SDK triggers an error.
    public var max: Int?
    /// The list of participants' objects.
    public var participants: [VTParticipant]?
    
    public init(strategy: VideoForwardingStrategy?, max: Int?, participants: [VTParticipant]?) {
        self.strategy = strategy
        self.max = max
        self.participants = participants
    }
}


@objcMembers public class VTReplayOptions: NSObject {
    public var offset: Int = 0
    public var conferenceAccessToken: String?
}

@objcMembers public class AudioProcessing: NSObject {
    public var send = AudioProcessingSender()
}

@objcMembers public class AudioProcessingSender: NSObject {
    public var audioProcessing: Bool = false
}

@objcMembers public class VTParticipantPermissions: NSObject {
    
    /// Conference participant.
    public var participant = VTParticipant()
    
    /// Participant's permissions.
    public var permissions = [VTConferencePermission]()
    
    public init(participant: VTParticipant, permissions: [VTConferencePermission]) {
        self.participant = participant
        self.permissions = permissions
    }
}
