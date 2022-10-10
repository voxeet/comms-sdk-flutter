import Foundation

internal enum BindingError: Error {

    case noRefreshTokenProvided
    case noCurrentParticipant
    case noCurrentConference
    case noConferenceId
    case noUrlProvided
    case noConference(String)
    case noParticipant(String)
    case noParticipantId(String)
}

extension BindingError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noRefreshTokenProvided:
            return "Refresh token is empty"
        case .noCurrentParticipant:
            return "No current session user."
        case .noConferenceId:
            return "Conference should contain conferenceId."
        case .noCurrentConference:
            return "Could not get current conference"
        case .noUrlProvided:
            return "No url provided"
        case let .noConference(id):
            return "Could not find the conference with id:\(id)."
        case let .noParticipant(participant):
            return "Could not find the participant: \(participant)"
        case let .noParticipantId(participantId):
            return "Couldn't find the participant with id: \(participantId)"
        }
    }
}
