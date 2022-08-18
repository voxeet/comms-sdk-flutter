import Foundation

internal enum BindingError: Error {

	case noRefreshTokenProvided
	case noCurrentParticipant
	case notRecording
	case noCurrentConference
	case noConferenceId
	case noConferenceStatus
	case noLocalStats
	case noUrlProvided
	case noCurrentFilePresentation
	case noCurrenVideoPresentation
	case noImageForPage(Int)
	case noThumbnailForPage(Int)
	case invalidFile(String)
	case invalidOptions(String)
	case unsupportedNoiseLevel(String)
	case noConference(String)
	case noParticipant(String)
	case noParticipantId(String)
	case waitingForSDKImplementation(String)
	case noSpatialScale
	case noSpatialDirection
	case noSpatialPosition
	case noAudioProcessing
	case noNoiseLevel
    case noPermission
}

extension BindingError: LocalizedError {

	var localizedDescription: String? {
		switch self {
		case .noRefreshTokenProvided:
			return "Refresh token is empty"
		case .noCurrentParticipant:
			return "No current session user."
		case .notRecording:
			return "The SDK does not record a conference."
		case .noConferenceId:
			return "Conference should contain conferenceId."
		case .noCurrentConference:
			return "Missing current conference."
		case .noConferenceStatus:
			return "Missing conference status."
		case .noLocalStats:
			return "Couldn't get any local stats."
		case .noUrlProvided:
			return "No url provided"
		case .noCurrentFilePresentation:
			return "Missing current file presentation."
		case .noCurrenVideoPresentation:
			return "Missing current video presentation."
		case let .noImageForPage(page):
			return "Couldn't find image for page: \(page)"
		case let .noThumbnailForPage(page):
			return "Couldn't find thumbnail for page: \(page)"
		case let .invalidFile(file):
			return "invalid file: \(file)"
		case let .invalidOptions(options):
			return "invalid options: \(options)"
		case let .unsupportedNoiseLevel(noiseLevel):
			return "unsupported noise level: \(noiseLevel)"
		case let .noConference(id):
			return "Couldn't find the conference with id:\(id)."
		case let .noParticipant(participant):
			return "Couldn't find the participant: \(participant)"
		case let .noParticipantId(participantId):
			return "Couldn't find the participant with id: \(participantId)"
		case let .waitingForSDKImplementation(version):
			return "Waiting for implementation in iOS SDK version: \(version)"
		case .noSpatialScale:
			return "Spatial scale was not provided"
		case .noSpatialDirection:
			return "Spatial direction was not provided"
		case .noSpatialPosition:
			return "Spatial position was not provided"
		case .noAudioProcessing:
			return "Audio processing was not enabled"
		case .noNoiseLevel:
			return "Noise level was not provided"
        case .noPermission:
            return "Pacticipant permission was not provided"
		}
	}
}
