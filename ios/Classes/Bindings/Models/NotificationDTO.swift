import Foundation
import VoxeetSDK

extension DTO {

    struct InvitationReceivedNotification: Codable {
        let conferenceID: String
        let conferenceAlias: String
        let participant: Participant

        init(invitationReceivedNotification: VTInvitationReceivedNotification) {
            conferenceID = invitationReceivedNotification.conferenceID
            conferenceAlias = invitationReceivedNotification.conferenceAlias
            participant = Participant(participant: invitationReceivedNotification.participant)
        }
    }
}
