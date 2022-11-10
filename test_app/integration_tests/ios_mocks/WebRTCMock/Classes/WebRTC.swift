import Foundation

@objc public enum MediaStreamType: UInt {
    case Camera = 0, ScreenShare = 1, Custom = 2
};

@objc public class MediaStream: NSObject {
    public let streamId: String
    public let type: MediaStreamType
    public let audioTracks: [AudioTrack]
    public let videoTracks: [VideoTrack]
    public init(streamId: String, type: MediaStreamType, audioTracks: [AudioTrack], videoTracks: [VideoTrack]) {
        self.streamId = streamId
        self.type = type
        self.audioTracks = audioTracks
        self.videoTracks = videoTracks
    }
}

@objc public class AudioTrack: NSObject {
    public let trackId: String
    public init(trackId: String) {
        self.trackId = trackId
    }
}

@objc public class VideoTrack: NSObject {
    public let trackId: String
    public init(trackId: String) {
        self.trackId = trackId
    }
}
