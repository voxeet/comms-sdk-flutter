import Foundation
import WebRTC

@objcMembers public class VTBaseNotification: NSObject {
    var type: String
    public internal(set) var conferenceID: String
    public internal(set) var conferenceAlias: String

    init(type: String, confID: String, confAlias: String) {
        self.type = type
        self.conferenceID = confID
        self.conferenceAlias = confAlias

        super.init()
    }
}

@objcMembers public class VTInvitationReceivedNotification: VTBaseNotification {
    public let participant: VTParticipant = .init()
}

@objcMembers public class VTConferenceStatusNotification: VTBaseNotification {
    public let live: Bool = false
    public var participants: [VTParticipant] = []
}

@objcMembers public class VTConferenceCreatedNotification: VTBaseNotification {}

@objcMembers public class VTConferenceEndedNotification: VTBaseNotification {}

@objcMembers public class VTParticipantJoinedNotification: VTBaseNotification {
    public let participant: VTParticipant = .init()
}

@objcMembers public class VTParticipantLeftNotification: VTBaseNotification {
    public let participant: VTParticipant = .init()
}

@objcMembers public class VTActiveParticipantsNotification: VTBaseNotification {
    public let participants: [VTParticipant] = []
    public let participantCount: Int = 0
}
