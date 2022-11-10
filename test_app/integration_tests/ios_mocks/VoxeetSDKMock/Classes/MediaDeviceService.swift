import Foundation

public enum MediaEngineComfortNoiseLevel: NSInteger {
	case `default` = 0
	case low = 1
	case medium = 2
	case off = 3
};

@objcMembers public class MediaDeviceService: NSObject {

	public var isFrontCamera: Bool = true
	public var noiseLevel: MediaEngineComfortNoiseLevel = .default

	var getComfortNoiseHasRun: Bool = false
	var getComfortNoiseLevelReturn: Error?
	public func getComfortNoiseLevel(completion: @escaping ((MediaEngineComfortNoiseLevel, Error?) -> Void)){
		getComfortNoiseHasRun = true
		completion(noiseLevel, getComfortNoiseLevelReturn)
	}

	var setComfortNoiseLevelArgs: MediaEngineComfortNoiseLevel?
	var setComfortNoiseLevelReturn: Error?
	public func setComfortNoiseLevel(comfortNoise: MediaEngineComfortNoiseLevel, completion: ((Error?) -> Void)? = nil) {
		noiseLevel = comfortNoise
		setComfortNoiseLevelArgs = comfortNoise
		completion?(setComfortNoiseLevelReturn)
	}

	var switchCameraHasRun: Bool = false
	public func switchCamera(completion: (() -> Void)? = nil) {
		switchCameraHasRun = true
	}

	var switchDeviceSpeakerHasRun: Bool = false
	public func switchDeviceSpeaker() {
		switchDeviceSpeakerHasRun = true
	}
}
