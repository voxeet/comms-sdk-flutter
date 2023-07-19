import Foundation

public enum ComfortNoiseLevel: NSInteger {
    case `default` = 0
    case low = 1
    case medium = 2
    case off = 3
};

public enum VoiceFont : String {
    case none
    case masculine
    case feminine
    case helium
    case darkModulation
    case brokenRobot
    case interference
    case abyss
    case wobble
    case starshipCaptain
    case nervousRobot
    case swarm
    case amRadio
};

@objcMembers public class AudioService: NSObject {

    public var local: LocalAudio = .init()

    public var remote: RemoteAudio = .init()
}

@objcMembers public class LocalAudio : NSObject {

    public var captureMode: AudioCaptureMode?
    public var noiseLevel: ComfortNoiseLevel = .default
    
    public let preview = AudioPreview()

    var startHasRun: Bool = false
    var startReturn: NSError?
    public func start(completion: ((_ error: Error?) -> Void)?) {
        startHasRun = true
        completion?(startReturn)
    }

    var stopHasRun: Bool = false
    var stopReturn: NSError?
    public func stop(completion: ((_ error: Error?) -> Void)?) {
        stopHasRun = true
        completion?(stopReturn)
    }

    var setComfortNoiseLevelArgs: ComfortNoiseLevel?
    var setComfortNoiseLevelReturn: Error?
    public func setComfortNoiseLevel(_ comfortNoise: ComfortNoiseLevel, completion: ((Error?) -> Void)? = nil) {
        noiseLevel = comfortNoise
        setComfortNoiseLevelArgs = comfortNoise
        completion?(setComfortNoiseLevelReturn)
    }

    var getComfortNoiseHasRun: Bool = false
    var getComfortNoiseLevelReturn: Error?
    public func getComfortNoiseLevel(completion: @escaping ((ComfortNoiseLevel?, Error?) -> Void)){
        getComfortNoiseHasRun = true
        completion(noiseLevel, getComfortNoiseLevelReturn)
    }
}

@objcMembers public class RemoteAudio : NSObject {

    var startArgs: VTParticipant?
    var startReturn: NSError?
    public func start(participant: VTParticipant, completion: ((_ error: NSError?) -> Void)?) {
        startArgs = participant
        completion?(startReturn)
    }

    var stopArgs: VTParticipant?
    var stopReturn: NSError?
    public func stop(participant: VTParticipant, completion: ((_ error: NSError?) -> Void)?) {
        stopArgs = participant
        completion?(stopReturn)
    }
}

@objcMembers public class StandardAudioCaptureMode : AudioCaptureMode {

    public enum NoiseReduction {
        case high, low
    }

    public let noiseReduction: NoiseReduction
    public let voiceFont: VoiceFont

    init(noiseReduction: NoiseReduction, voiceFont: VoiceFont) {
        self.noiseReduction = noiseReduction
        self.voiceFont = voiceFont
    }
}

@objcMembers public class UnprocessedAudioCaptureMode : AudioCaptureMode {}

@objcMembers public class AudioCaptureMode: NSObject {

    public static func standard(noiseReduction: StandardAudioCaptureMode.NoiseReduction, voiceFont: VoiceFont = .none) -> StandardAudioCaptureMode {
        return .init(noiseReduction: noiseReduction, voiceFont: voiceFont)
    }

    public static func unprocessed() -> UnprocessedAudioCaptureMode {
        return .init()
    }
}
