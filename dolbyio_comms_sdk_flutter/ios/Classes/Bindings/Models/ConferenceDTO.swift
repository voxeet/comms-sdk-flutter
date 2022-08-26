import Foundation
import VoxeetSDK

extension DTO {
    
    struct Confrence: Codable {
        
        let id: String?
        let alias: String?
        let isNew: Bool?
        let participants: [Participant]
        let params: ConferenceParameters?
        let status: ConferenceStatus
        let pinCode: String?
        
        init(conference: VTConference) {
            self.id = conference.id
            self.alias = conference.alias
            self.isNew = conference.isNew
            self.participants = conference.participants.map { Participant(participant: $0) }
            self.params = ConferenceParameters(conferenceParameters: conference.params)
            self.status = ConferenceStatus(status: conference.status)
            self.pinCode = conference.pinCode
        }
    }
    
    struct JoinOptions: Codable {
        
        let constraints: JoinOptionsConstraints?
        let maxVideoForwarding: Int?
        let conferenceAccessToken: String?
        let spatialAudio: Bool?
        
        init(conferenceJoinOptions: VTJoinOptions) {
            self.constraints = JoinOptionsConstraints(
                joinOptionsConstraints: conferenceJoinOptions.constraints
            )
            self.maxVideoForwarding = conferenceJoinOptions.maxVideoForwarding?.intValue
            self.conferenceAccessToken = conferenceJoinOptions.conferenceAccessToken
            self.spatialAudio = conferenceJoinOptions.spatialAudio
        }
        
        func toSdkType() -> VTJoinOptions {
            let joinOptions = VTJoinOptions()

            if let constraints = constraints {
                joinOptions.constraints = constraints.toSdkType()
            }
            joinOptions.maxVideoForwarding = maxVideoForwarding.map { NSNumber(value: $0) }
            joinOptions.conferenceAccessToken = conferenceAccessToken
            if let spatialAudio = spatialAudio {
                joinOptions.spatialAudio = spatialAudio
            }

            return joinOptions
        }
    }
    
    struct JoinOptionsConstraints: Codable {
        
        let audio: Bool
        let video: Bool
        
        init(joinOptionsConstraints: VTJoinOptionsConstraints) {
            self.audio = joinOptionsConstraints.audio
            self.video = joinOptionsConstraints.video
        }
        
        func toSdkType() -> VTJoinOptionsConstraints {
            let joinOptionsConstraints = VTJoinOptionsConstraints()
            joinOptionsConstraints.audio = audio
            joinOptionsConstraints.video = video
            return joinOptionsConstraints
        }
    }
    
    struct ConferenceOptions: Codable {
        
        let alias: String?
        let params: ConferenceParameters?
        let pinCode: ConferencePinCode?
        
        init(conferenceOptions: VTConferenceOptions) {
            self.alias = conferenceOptions.alias
            self.params = ConferenceParameters(conferenceParameters: conferenceOptions.params)
            self.pinCode = conferenceOptions.pinCode.map { ConferencePinCode(pinCode: $0) }
        }
        
        func toSdkType() -> VTConferenceOptions {
            let conferenceOptions = VTConferenceOptions()
            conferenceOptions.alias = alias
            if let params = params {
                params.toSdkType(conferenceParameters: conferenceOptions.params)
            }
            conferenceOptions.pinCode = pinCode.map { $0.pinCode }
            return conferenceOptions
        }
    }
    
    struct ConferenceParameters: Codable {
        
        let liveRecording: Bool?
        let rtcpMode: String?
        let stats: Bool?
        let ttl: Double?
        let videoCodec: String?
        let dolbyVoice: Bool?
        
        init(conferenceParameters: VTConferenceParameters) {
            self.liveRecording = conferenceParameters.liveRecording
            self.rtcpMode = conferenceParameters.rtcpMode
            self.stats = conferenceParameters.stats
            self.ttl = conferenceParameters.ttl?.doubleValue
            self.videoCodec = conferenceParameters.videoCodec
            self.dolbyVoice = conferenceParameters.dolbyVoice
        }
        
        func toSdkType(conferenceParameters: VTConferenceParameters) {
            if let liveRecording = liveRecording {
                conferenceParameters.liveRecording = liveRecording
            }
            conferenceParameters.rtcpMode = rtcpMode
            if let stats = stats {
                conferenceParameters.stats = stats
            }
            conferenceParameters.ttl = ttl.map { NSNumber(value: $0) }
            conferenceParameters.videoCodec = videoCodec
            if let dolbyVoice = dolbyVoice {
                conferenceParameters.dolbyVoice = dolbyVoice
            }
        }
    }
    
    struct ConferencePermission: Codable {
        
        let conferencePermission: VTConferencePermission
        
        init(conferencePermision: VTConferencePermission) {
            self.conferencePermission = conferencePermision
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.singleValueContainer()
            
            switch try container.decode(String.self) {
            case "INVITE": conferencePermission = .invite
            case "KICK": conferencePermission = .kick
            case "UPDATE_PERMISSIONS": conferencePermission = .updatePermissions
            case "JOIN": conferencePermission = .join
            case "SEND_AUDIO": conferencePermission = .sendAudio
            case "SEND_VIDEO": conferencePermission = .sendVideo
            case "SHARE_SCREEN": conferencePermission = .shareScreen
            case "SHARE_VIDEO": conferencePermission = .shareVideo
            case "SHARE_FILE": conferencePermission = .shareFile
            case "SEND_MESSAGE": conferencePermission = .sendMessage
            case "RECORD": conferencePermission = .record
            case "STREAM": conferencePermission = .stream
            default: fatalError("TODO: Throw actual error here")
            }
        }

        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch conferencePermission {
            case .invite: try container.encode("INVITE")
            case .kick: try container.encode("KICK")
            case .updatePermissions: try container.encode("UPDATE_PERMISSIONS")
            case .join: try container.encode("JOIN")
            case .sendAudio: try container.encode("SEND_AUDIO")
            case .sendVideo: try container.encode("SEND_VIDEO")
            case .shareScreen: try container.encode("SHARE_SCREEN")
            case .shareVideo: try container.encode("SHARE_VIDEO")
            case .shareFile: try container.encode("SHARE_FILE")
            case .sendMessage: try container.encode("SEND_MESSAGE")
            case .record: try container.encode("RECORD")
            case .stream: try container.encode("STREAM")
            @unknown default: fatalError("TODO: Throw actual error here")
            }
        }

        func toSdkType() -> VTConferencePermission {
            return conferencePermission
        }
    }
    
    struct ConferenceStatus: Codable {
        
        private let status: VTConferenceStatus
        
        init(status: VTConferenceStatus) {
            self.status = status
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.singleValueContainer()
            
            switch try container.decode(String.self) {
            case "CREATING": status = .creating
            case "CREATED": status = .created
            case "JOINING": status = .joining
            case "JOINED": status = .joined
            case "LEAVING": status = .leaving
            case "LEFT": status = .left
            case "ENDED": status = .ended
            case "DESTROYED": status = .destroyed
            case "ERROR": status = .error
            default: fatalError("TODO: Throw actual error here")
            }
        }

        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch status {
            case .creating: try container.encode("CREATING")
            case .created: try container.encode("CREATED")
            case .joining: try container.encode("JOINING")
            case .joined: try container.encode("JOINED")
            case .leaving: try container.encode("LEAVING")
            case .left: try container.encode("LEFT")
            case .ended: try container.encode("ENDED")
            case .destroyed: try container.encode("DESTROYED")
            case .error: try container.encode("ERROR")
            @unknown default: fatalError("TODO: Throw actual error here")
            }
        }

    }
    
    struct ConferencePinCode: Codable {
        
        let pinCode: NSNumber
        
        init(pinCode: NSNumber) {
            self.pinCode = pinCode
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            pinCode = NSNumber(value: try container.decode(Int.self))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(pinCode.intValue)
        }
    }

    struct SpatialDirection: Codable {
        let x, y, z: Double

        init(spatialDirection: VTSpatialDirection) {
            self.x = spatialDirection.x
            self.y = spatialDirection.y
            self.z = spatialDirection.z
        }

        func toSdkType() -> VTSpatialDirection {
            return VTSpatialDirection(x: x, y: y, z: z)
        }
    }

    struct SpatialPosition: Codable {
        let x, y, z: Double

        init(spatialPosition: VTSpatialPosition) {
            self.x = spatialPosition.x
            self.y = spatialPosition.y
            self.z = spatialPosition.z
        }
        
        func toSdkType() -> VTSpatialPosition {
            return VTSpatialPosition(x: x, y: y, z: z)
        }
    }

    struct SpatialScale: Codable {
        let x, y, z: Double

        init(spatialScale: VTSpatialScale) {
            self.x = spatialScale.x
            self.y = spatialScale.y
            self.z = spatialScale.z
        }

        func toSdkType() -> VTSpatialScale {
            return VTSpatialScale(x: x, y: y, z: z)
        }
    }

    struct ReplayOptions: Codable {
        let offset: Int
        let conferenceAccessToken: String?

        init(replayOptions: VTReplayOptions) {
            self.offset = replayOptions.offset
            self.conferenceAccessToken = replayOptions.conferenceAccessToken
        }

        init?(offset: Int?, conferenceAccessToken: String?) {
            guard let offset = offset else {
                return nil
            }
            self.offset = offset
            self.conferenceAccessToken = conferenceAccessToken
        }

        func toSdkType() -> VTReplayOptions {
            let options = VTReplayOptions()
            options.offset = offset
            options.conferenceAccessToken = conferenceAccessToken
            return options
        }
    }
    
    struct AudioProcessingOptions: Codable {
        let send: AudioProcessingSenderOptions?
    }
    
    struct AudioProcessingSenderOptions: Codable {
        let audioProcessing: Bool?
    }
}
