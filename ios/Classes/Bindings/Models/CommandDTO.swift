import Foundation
import VoxeetSDK

extension DTO {
    struct MessageReceivedData: Codable {
        let message: String
        let participant: Participant
        
        init(message: String, participant: VTParticipant) {
            self.message = message
            self.participant = DTO.Participant(participant: participant)
        }
    }
}

