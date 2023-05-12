import Foundation
import WebRTC

open class VTVideoView: UIView {
    
    /// Current media stream attached to the video renderer.
    public weak var mediaStream: MediaStream? = nil
    
    /// Current participant ID attached to the video renderer.
    public var userID: String? = nil
    
    public func attach(participant: VTParticipant, stream: MediaStream) {
        fatalError("UnImplemented")
    }
    
    public func unattach() {
        fatalError("UnImplemented")
    }

    public func contentFill(_ fill: Bool, animated: Bool) {
        fatalError("UnImplemented")
    }
}
