import Foundation
import WebRTC

@objcMembers public class VideoPresentationService: NSObject {
    
    public internal(set) var current: VTVideoPresentation?
    public internal(set) var state: VTVideoPresentationState = .stopped
    
    var startHasRun: Bool = false
    var startArgs: URL?
    var startReturn: NSError?
    public func start(url: URL, completion: ((_ error: NSError?) -> Void)? = nil) {
        state = .playing
        startArgs = url
        startHasRun = true
        completion?(startReturn)
    }
    
    var stopHasRun: Bool = false
    var stopReturn: NSError?
    public func stop(completion: ((_ error: NSError?) -> Void)? = nil) {
        state = .stopped
        stopHasRun = true
        completion?(stopReturn)
    }
    
    var playHasRun: Bool = false
    var playReturn: NSError?
    public func play(completion: ((_ error: NSError?) -> Void)? = nil) {
        state = .playing
        playHasRun = true
        completion?(playReturn)
    }
    
    var pauseHasRun: Bool = false
    var pauseArgs: Int?
    var pauseReturn: NSError?
    public func pause(timestamp: Int, completion: ((_ error: NSError?) -> Void)? = nil) {
        state = .paused
        pauseArgs = timestamp
        pauseHasRun = true
        completion?(pauseReturn)
    }
    
    var seekHasRun: Bool = false
    var seekArgs: Int?
    var seekReturn: NSError?
    public func seek(timestamp: Int, completion: ((_ error: NSError?) -> Void)? = nil) {
        seekArgs = timestamp
        seekHasRun = true
        completion?(seekReturn)
    }
}

@objc public protocol VTVideoPresentationDelegate {
    /// Emitted when a video presentation is started.
    @objc func started(videoPresentation: VTVideoPresentation)
    /// Emitted when a video presentation is stopped.
    @objc func stopped(videoPresentation: VTVideoPresentation)
    /// Emitted when a video presentation is played.
    @objc func played(videoPresentation: VTVideoPresentation)
    /// Emitted when a video presentation is paused.
    @objc func paused(videoPresentation: VTVideoPresentation)
    /// Emitted when a video presentation is sought.
    @objc func sought(videoPresentation: VTVideoPresentation)
}
