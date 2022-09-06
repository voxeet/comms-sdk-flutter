import Foundation
import VoxeetSDK

extension DTO {

    struct InvitationReceivedNotification: Codable {
        let conferenceId: String
        let conferenceAlias: String
        let participant: Participant

        init(invitationReceivedNotification: VTInvitationReceivedNotification) {
            conferenceId = invitationReceivedNotification.conferenceID
            conferenceAlias = invitationReceivedNotification.conferenceAlias
            participant = Participant(participant: invitationReceivedNotification.participant)
        }
    }
}
