import Foundation
import VoxeetSDK
import WebRTC

extension DTO {
    
    struct ParticipantInfo: Codable {
        
        let externalId: String?
        let name: String?
        let avatarUrl: String?
        
        init(participantInfo: VTParticipantInfo) {
            self.externalId = participantInfo.externalID
            self.name = participantInfo.name
            self.avatarUrl = participantInfo.avatarURL
        }
        
        func toSdkType() -> VTParticipantInfo {
            return VTParticipantInfo(externalID: externalId, name: name, avatarURL: avatarUrl)
        }
    }

    struct ParticipantType: Codable {
        
        let participantType: VTParticipantType
        
        init(participantType: VTParticipantType) {
            self.participantType = participantType
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.singleValueContainer()
            
            switch try container.decode(String.self).uppercased() { // TODO: remove uppercased()
            case "UNKNOWN": participantType = .none
            case "USER": participantType = .user
            case "LISTENER": participantType = .listener
            default: throw EncoderError.decoderFailed()
            }
        }

        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch participantType {
            case .user: try container.encode("USER")
            case .listener: try container.encode("LISTENER")
            case .pstn: try container.encode("UNKNOWN")
            case .none: try container.encode("UNKNOWN")
            case .mixer: try container.encode("UNKNOWN")
            @unknown default: throw EncoderError.encoderFailed()
            }
        }
        
    }

    struct ParticipantStatus: Codable {
        
        let participantStatus: VTParticipantStatus
        
        init(participantStatus: VTParticipantStatus) {
            self.participantStatus = participantStatus
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "RESERVED": participantStatus = .reserved
            case "INACTIVE": participantStatus = .inactive
            case "DECLINE": participantStatus = .decline
            case "CONNECTING": participantStatus = .connecting
            case "CONNECTED": participantStatus = .connected
            case "LEFT": participantStatus = .left
            case "WARNING": participantStatus = .warning
            case "ERROR": participantStatus = .error
            case "KICKED": participantStatus = .kicked
            default: fatalError("TODO: Throw actual error here")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch participantStatus {
            case .reserved: try container.encode("RESERVED")
            case .inactive: try container.encode("INACTIVE")
            case .decline: try container.encode("DECLINE")
            case .connecting: try container.encode("CONNECTING")
            case .connected: try container.encode("CONNECTED")
            case .left: try container.encode("LEFT")
            case .warning: try container.encode("WARNING")
            case .error: try container.encode("ERROR")
            case .kicked: try container.encode("KICKED")
            @unknown default: fatalError("TODO: Throw actual error here")
            }
        }
    }
    
    struct ParticipantPermissions: Codable {
        
        let participant: Participant
        let permissions: [ConferencePermission]
        
        init(participantPermission: VTParticipantPermissions) {
            self.participant = Participant(participant: participantPermission.participant)
            self.permissions = participantPermission.permissions.map { ConferencePermission(conferencePermision: $0) }
        }
        
        func toSdkType() throws -> VTParticipantPermissions {
            guard let vtParticipant = VoxeetSDK.shared.conference.current?.findParticipant(with: participant.id) else {
                fatalError("TODO: Throw actual error here")
            }
            let vtParticipantPermissions = VTParticipantPermissions(
                participant: vtParticipant,
                permissions: permissions.map { $0.conferencePermission }
            )
            return vtParticipantPermissions
        }
    }

    struct MediaStream: Codable {
        
        let id: String
        let type: MediaStreamType
        let audioTracks: [AudioTrack]
        let videoTracks: [VideoTrack]
        let label: String

        init(mediaStream: WebRTC.MediaStream) {
            id = mediaStream.streamId
            type = MediaStreamType(mediaStreamType: mediaStream.type)
            audioTracks = mediaStream.audioTracks.map { $0.trackId }
            videoTracks = mediaStream.videoTracks.map { $0.trackId }
            label = ""
        }
    }
    
    struct MediaStreamType: Codable {
        
        let mediaStreamType: WebRTC.MediaStreamType
        
        init(mediaStreamType: WebRTC.MediaStreamType) {
            self.mediaStreamType = mediaStreamType
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "CAMERA": mediaStreamType = .Camera
            case "SCREEN_SHARE": mediaStreamType = .ScreenShare
            case "CUSTOM": mediaStreamType = .Custom
            default: throw EncoderError.decoderFailed()
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch mediaStreamType {
            case .Camera: try container.encode("CAMERA")
            case .ScreenShare: try container.encode("SCREEN_SHARE")
            case .Custom: try container.encode("CUSTOM")
            @unknown default: throw EncoderError.encoderFailed()
            }
        }
    }
    
    typealias AudioTrack = String
    typealias VideoTrack = String
    
    struct Participant: Codable {
        
        let id: String?
        let info: ParticipantInfo
        let type: ParticipantType
        let status: ParticipantStatus
        let streams: [MediaStream]?
        let audioReceivingFrom: Bool?
        let audioTransmitting: Bool?
        
        init(participant: VTParticipant) {
            self.id = participant.id
            self.info = ParticipantInfo(participantInfo: participant.info)
            self.type = ParticipantType(participantType: participant.type)
            self.status = ParticipantStatus(participantStatus: participant.status)
            self.streams = participant.streams.map { MediaStream(mediaStream: $0) }
            self.audioReceivingFrom = participant.audioReceivingFrom
            self.audioTransmitting = participant.audioTransmitting
        }
    }

    struct ParticipantInvited: Codable {

        let info: ParticipantInfo
        let permissions: [ConferencePermission]?

        init(participantInvited: VTParticipantInvited) {
            self.info = ParticipantInfo(participantInfo: participantInvited.info)
            self.permissions = participantInvited.permissions?.map { ConferencePermission(conferencePermision: $0) }
        }

        func toSdkType() -> VTParticipantInvited {
            return VTParticipantInvited(
                info: info.toSdkType(),
                permissions: permissions?.map { $0.toSdkType() }
            )
        }
    }
}
