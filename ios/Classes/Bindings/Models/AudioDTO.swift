import Foundation
import VoxeetSDK
import WebRTC

typealias VTAudioCaptureMode = AudioCaptureMode

extension DTO {

    struct AudioCaptureOptions: Codable {
        let mode: AudioCaptureMode
        let noiseReduction: NoiseReduction?

        init(audioCaptureMode: VTAudioCaptureMode) throws {
            self.mode = try .init(audioCaptureMode: audioCaptureMode)
            if let audioCaptureMode = audioCaptureMode as? StandardAudioCaptureMode {
                self.noiseReduction = .init(noiseReduction: audioCaptureMode.noiseReduction)
            } else {
                self.noiseReduction = nil
            }
        }

        func toSdk() throws -> VTAudioCaptureMode?  {
            switch mode.mode {
            case .standard:
                guard let noiseReduction = noiseReduction?.noiseReduction else {
                    throw EncoderError.notExist()
                }
                return .standard(noiseReduction: noiseReduction)
            case .unprocessed:
                return .unprocessed()
            }
        }
    }

    enum Mode: String {
        case standard, unprocessed
    }

    struct AudioCaptureMode: Codable {

        let mode: Mode

        init(audioCaptureMode: VTAudioCaptureMode) throws {
            switch audioCaptureMode {
            case is StandardAudioCaptureMode:
                mode = .standard
            case is UnprocessedAudioCaptureMode:
                mode = .unprocessed
            default:
                throw EncoderError.notImplemented()
            }
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()

            switch try container.decode(String.self) {
            case "standard": mode = .standard
            case "unprocessed": mode = .unprocessed
            default: throw EncoderError.decoderFailed()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch mode {
            case .standard: try container.encode("standard")
            case .unprocessed: try container.encode("unprocessed")
            }
        }
    }

    struct NoiseReduction: Codable {

        let noiseReduction: StandardAudioCaptureMode.NoiseReduction

        init(noiseReduction: StandardAudioCaptureMode.NoiseReduction) {
            self.noiseReduction = noiseReduction
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()

            switch try container.decode(String.self) {
            case "low": noiseReduction = .low
            case "high": noiseReduction = .high
            default: throw EncoderError.decoderFailed()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch noiseReduction {
            case .low: try container.encode("low")
            case .high: try container.encode("high")
            }
        }
    }
}
