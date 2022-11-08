import Foundation

@objcMembers public class VTVideoPresentation: NSObject {
    public internal(set) var participant: VTParticipant
    public internal(set) var url: URL
    public internal(set) var timestamp: TimeInterval
    
    init(participant: VTParticipant, url: URL, timestamp: TimeInterval) {
        self.participant = participant
        self.url = url
        self.timestamp = timestamp
    }
}

@objc public enum VTVideoPresentationState: Int {
    case stopped
    case playing
    case paused
}
