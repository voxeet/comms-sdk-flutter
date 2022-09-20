import Foundation
import VoxeetSDK
import WebRTC

extension DTO {

    struct RecordingInformation: Codable {
        let participantId: String?
        let startTimestamp: Int?
        let recordingStatus: RecordingStatus?
    }

    struct RecordingStatus: Codable {

        let recordingStatus: VTRecordingStatus

        init(recordingStatus: VTRecordingStatus) {
            self.recordingStatus = recordingStatus
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()

            switch try container.decode(String.self).uppercased() { // TODO: remove uppercased()
            case "RECORDING": recordingStatus = .recording
            case "NOT_RECORDING": recordingStatus = .notRecording
            default: throw EncoderError.decoderFailed()
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch recordingStatus {
            case .recording: try container.encode("RECORDING")
            case .notRecording: try container.encode("NOT_RECORDING")
            @unknown default: throw EncoderError.encoderFailed()
            }
        }

        func toSdkType() -> VTRecordingStatus {
            return recordingStatus
        }
    }

}
