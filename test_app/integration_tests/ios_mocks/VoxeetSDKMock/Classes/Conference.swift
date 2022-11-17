import Foundation
import WebRTC

@objcMembers public class VTConference: NSObject {

    public var mockIdValue: String? = nil
    public var id: String { mockIdValue! }

    public var mockAliasValue: String? = nil
    public var alias: String { mockAliasValue! }

    public var isNew: Bool = false
    public var participants = [VTParticipant]()
    public var params = VTConferenceParameters()
    public var permissions = VTConferencePermission.all()
    public var status: VTConferenceStatus = .ended
    public var pinCode: String? = nil
    public var spatialAudioStyle: SpatialAudioStyle?

}

@objcMembers public class VTConferenceParameters: NSObject {
    public var liveRecording: Bool = false
    public var rtcpMode: String?
    public var stats: Bool = false
    public var ttl: NSNumber?
    public var videoCodec: String? = "H264"
    public var dolbyVoice: Bool = true
    public var audioOnly: Bool = false
}

@objc public enum VTConferenceStatus: Int {
    case creating
    case created
    case joining
    case joined
    case leaving
    case left
    case ended
    case destroyed
    case error
}

@objc public enum VTConferencePermission: Int {
    case invite
    case kick
    case updatePermissions
    case join
    case sendAudio
    case sendVideo
    case shareScreen
    case shareVideo
    case shareFile
    case sendMessage
    case record
    case stream
    
    static func all() -> [VTConferencePermission] {
        return [.invite, .kick, .updatePermissions, .join, .sendAudio, .sendVideo, .shareScreen, .shareVideo, .shareFile, .sendMessage, .record, .stream]
    }
}

@objc public enum SpatialAudioStyle: Int {
    case individual
    case shared
    case disabled
}

internal extension SpatialAudioStyle {
    enum StringValue: String {
        case individual
        case shared
        case disabled

        var style: SpatialAudioStyle? {
            switch self {
            case .individual:
                return .individual
            case .shared:
                return .shared
            case .disabled:
                return .disabled
            }
        }
    }

    var description: StringValue {
        switch self {
        case .individual:
            return .individual
        case .shared:
            return .shared
        case .disabled:
            return .disabled
        }
    }

    static var styles: [SpatialAudioStyle] {
        [
            .individual,
            .shared,
            .disabled
        ]
    }

    static var stylesAsString: [String] {
        styles.map { $0.description.rawValue }
    }
}
    

@objcMembers public class VTParticipant: NSObject {
    public internal(set) var id: String?
    public internal(set) var info = VTParticipantInfo()
    public internal(set) var type: VTParticipantType = .none
    public internal(set) var status: VTParticipantStatus = .connecting
    public internal(set) var streams = [MediaStream]()
    public var audioReceivingFrom: Bool = false
    public var audioTransmitting: Bool = false
}

@objcMembers public class VTParticipantInfo: NSObject {
    public var externalID: String?
    public var name: String?
    public var avatarURL: String?
    
    public override init() {
        super.init()
    }
    
    public init(externalID: String?, name: String?, avatarURL: String?) {
        self.externalID = externalID
        self.name = name
        self.avatarURL = avatarURL
    }
}

@objc public enum VTParticipantType: Int {
    case none
    case user
    case pstn
    case listener
    case mixer
    
    static func convert(type: String) -> VTParticipantType {
        switch(type) { /* "DVCS" type is filtered when appending a new participant */
        case "NONE", "ROBOT_NONE":
            return .none
        case "USER", "ROBOT":
            return .user
        case "PSTN", "ROBOT_PSTN":
            return .pstn
        case "LISTENER", "ROBOT_LISTENER":
            return .listener
        case "MIXER", "ROBOT_MIXER":
            return .mixer
        default:
            return .none
        }
    }
}

@objc public enum VTParticipantStatus: Int {
    case reserved
    case inactive
    case decline
    case connecting
    case connected
    case left
    case warning
    case error
    case kicked
    
    static func convert(status: String) -> VTParticipantStatus {
        switch(status) {
        case "RESERVED":
            return .reserved
        case "INACTIVE":
            return .inactive
        case "DECLINE":
            return .decline
        case "CONNECTING":
            return .connecting
        case "ON_AIR":
            return .connected
        case "LEFT":
            return .left
        case "WARNING":
            return .warning
        case "ERROR":
            return .error
        default:
            return .connecting
        }
    }
}

@objcMembers public class VTParticipantInvited: NSObject {
    public var info: VTParticipantInfo = .init()
    public var permissions: [VTConferencePermission]?

    public init(info: VTParticipantInfo, permissions: [VTConferencePermission]? = nil) {
        self.info = info
        self.permissions = permissions
    }
}

@objc public class VTSpatialPosition : NSObject {
	public var x: Double
	public var y: Double
	public var z: Double

	public init(x:Double, y:Double, z:Double) {
		self.x = x
		self.y = y
		self.z = z
	}
}

@objc public class VTSpatialDirection : NSObject {
	public var x: Double
	public var y: Double
	public var z: Double

	public init(x:Double, y:Double, z:Double) {
		self.x = x
		self.y = y
		self.z = z
	}
}

@objc public class VTSpatialScale : NSObject {
	public var x: Double
	public var y: Double
	public var z: Double

	public init(x:Double, y:Double, z:Double) {
		self.x = x
		self.y = y
		self.z = z
	}
}

@objc public enum VideoForwardingStrategy: Int {
    /// Selects participants based on their audio volume, which means that the local participant receives video streams
    /// only from active speakers.
    case lastSpeaker
    /// Selects participants based on the distance from the local participant.
    /// This means that the local participant receives video streams only from the nearest participants.
    /// This strategy is available only in conferences enabled with spatial audio.
    case closestUser
}

internal extension VideoForwardingStrategy {
    var requestValue: String {
        switch self {
        case .lastSpeaker:
            return "lastSpeakerStrategy"
        case .closestUser:
            return "closestUserStrategy"
        }
    }
}
