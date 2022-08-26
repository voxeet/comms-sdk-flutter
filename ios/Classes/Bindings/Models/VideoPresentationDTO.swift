import Foundation
import VoxeetSDK

extension DTO {
    
    struct VideoPresentation: Codable {
        let owner: Participant?
        let timestamp: TimeInterval?
        let url: String?
        
        init(videoPresentation: VTVideoPresentation) {
            owner = Participant.init(participant: videoPresentation.participant)
            timestamp = videoPresentation.timestamp
            url = videoPresentation.url.absoluteString
        }
    }
    
    struct VideoPresentationState: Codable {
        
        let state: VTVideoPresentationState
        
        init(state: VTVideoPresentationState) {
            self.state = state
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.singleValueContainer()
            
            switch try container.decode(String.self) {
            case "stopped": state = .stopped
            case "play": state = .playing
            case "paused": state = .paused
            default: fatalError("TODO: Throw actual error here")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch state {
            case .stopped: try container.encode("stopped")
            case .playing: try container.encode("play")
            case .paused: try container.encode("paused")
            @unknown default: fatalError("TODO: Throw actual error here")
            }
        }
        
        func toSdkType() -> VTVideoPresentationState {
            return state
        }
    }
}
