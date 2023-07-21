import Foundation
import VoxeetSDK
import WebRTC

typealias VTAudioCaptureMode = AudioCaptureMode
typealias VTVoiceFont = VoiceFont
typealias VTRecorderStatus = RecorderStatus

extension DTO {

    struct AudioCaptureOptions: Codable {
        let mode: AudioCaptureMode
        let noiseReduction: NoiseReduction?
        let voiceFont: VoiceFont?

        init(audioCaptureMode: VTAudioCaptureMode) throws {
            self.mode = try .init(audioCaptureMode: audioCaptureMode)
            if let audioCaptureMode = audioCaptureMode as? StandardAudioCaptureMode {
                self.noiseReduction = .init(noiseReduction: audioCaptureMode.noiseReduction)
                self.voiceFont = .init(voiceFont: audioCaptureMode.voiceFont)
            } else {
                self.noiseReduction = nil
                self.voiceFont = nil
            }
        }

        func toSdk() throws -> VTAudioCaptureMode  {
            switch mode.mode {
            case .standard:
                guard let noiseReduction = noiseReduction?.noiseReduction,
                      let voiceFont = voiceFont?.voiceFont
                else {
                    throw EncoderError.notExist()
                }
                return .standard(noiseReduction: noiseReduction, voiceFont: voiceFont)
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

    struct VoiceFont: Codable {

        let voiceFont: VTVoiceFont

        init(voiceFont: VTVoiceFont) {
            self.voiceFont = voiceFont
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()

            switch try container.decode(String.self) {
            case "masculine": voiceFont = .masculine
            case "feminine": voiceFont = .feminine
            case "helium": voiceFont = .helium
            case "dark_modulation": voiceFont = .darkModulation
            case "broken_robot": voiceFont = .brokenRobot
            case "interference": voiceFont = .interference
            case "abyss": voiceFont = .abyss
            case "wobble": voiceFont = .wobble
            case "starship_captain": voiceFont = .starshipCaptain
            case "nervous_robot": voiceFont = .nervousRobot
            case "swarm": voiceFont = .swarm
            case "am_radio": voiceFont = .amRadio
            case "none": voiceFont = .none

            default: throw EncoderError.decoderFailed()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch voiceFont {
            case .masculine: try container.encode("masculine")
            case .feminine: try container.encode("feminine")
            case .helium: try container.encode("helium")
            case .darkModulation: try container.encode("dark_modulation")
            case .brokenRobot: try container.encode("broken_robot")
            case .interference: try container.encode("interference")
            case .abyss: try container.encode("abyss")
            case .wobble: try container.encode("wobble")
            case .starshipCaptain: try container.encode("starship_captain")
            case .nervousRobot: try container.encode("nervous_robot")
            case .swarm: try container.encode("swarm")
            case .amRadio: try container.encode("am_radio")
            case .none: try container.encode("none")
            }
        }
    }
    
    struct RecorderStatus: Codable {
        
        let recorderStatus: VTRecorderStatus
        
        init(recorderStatus: VTRecorderStatus) {
            self.recorderStatus = recorderStatus
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "NoRecordingAvailable": recorderStatus = .noRecordingAvailable
            case "RecordingAvailable": recorderStatus = .recordingAvailable
            case "Recording": recorderStatus = .recording
            case "Playing": recorderStatus = .playing
            case "Released": recorderStatus = .released
            default: throw EncoderError.decoderFailed()
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch recorderStatus {
            case .noRecordingAvailable: try container.encode("NoRecordingAvailable")
            case .recordingAvailable: try container.encode("RecordingAvailable")
            case .recording: try container.encode("Recording")
            case .playing: try container.encode("Playing")
            case .released: try container.encode("Released")
            @unknown default: throw EncoderError.encoderFailed()
            }
        }
    }
}
