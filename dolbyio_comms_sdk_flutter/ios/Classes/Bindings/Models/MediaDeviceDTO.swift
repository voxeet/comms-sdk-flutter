import Foundation
import VoxeetSDK
import WebRTC

extension DTO {
    
    struct ComfortNoiseLevel: Codable {
        
        let noiseLevel: MediaEngineComfortNoiseLevel
        
        init(noiseLevel: MediaEngineComfortNoiseLevel) {
            self.noiseLevel = noiseLevel
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.singleValueContainer()
            
            switch try container.decode(String.self) {
            case "default": noiseLevel = .default
            case "low": noiseLevel = .low
            case "medium": noiseLevel = .medium
            case "off": noiseLevel = .off
            default: fatalError("TODO: Throw actual error here")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch noiseLevel {
            case .default: try container.encode("default")
            case .low: try container.encode("low")
            case .medium: try container.encode("medium")
            case .off: try container.encode("off")
            @unknown default: fatalError("TODO: Throw actual error here")
            }
        }
        
        func toSdkType() -> MediaEngineComfortNoiseLevel {
            return noiseLevel
        }
    }
    
}
