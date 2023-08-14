import Foundation

public enum AudioPreviewStatus {
    case noRecordingAvailable
    case recordingAvailable
    case recording
    case playing
    case released
}

public class AudioPreview {
    
    public var captureModeReturn: [AudioCaptureMode] = []
    public var captureModeGetterRunCounter = 0
    public var captureModeSetterArgs: [AudioCaptureMode] = []
    public var captureMode: AudioCaptureMode {
        get {
            captureModeGetterRunCounter += 1
            return captureModeReturn.popLast()!
        }
        set {
            captureModeSetterArgs.append(newValue)
        }
    }
    
    public var statusReturn: [AudioPreviewStatus] = []
    public var statusHasRunCounter = 0
    public var status: AudioPreviewStatus {
        statusHasRunCounter += 1
        return statusReturn.popLast()!
    }
    
    public var onStatusChanged: ((_ status: AudioPreviewStatus) -> Void)?

    public var recordArgs: [Int] = []
    public var recordReturnError: [Error?] = []
    public func record(duration: Int, completion: @escaping (_ error: Error?) -> Void) {
        recordArgs.append(duration)
        DispatchQueue.main.async {
            completion(self.recordReturnError.popLast()!)
        }
    }
    
    public func record(completion: @escaping (_ error: Error?) -> Void) {
        fatalError("Record withouth duration should not be used.")
    }
    
    public var playArgs: [Bool] = []
    public var playReturnError: [Error?] = []
    public func play(loop: Bool, completion: @escaping (_ error: Error?) -> Void) {
        playArgs.append(loop)
        DispatchQueue.main.async {
            completion(self.playReturnError.popLast()!)
        }
    }
    
    public func play(completion: @escaping (_ error: Error?) -> Void) {
        fatalError("Play without the loop argument should not be used.")
    }
    
    public var stopHasRun: Bool = false
    @discardableResult
    public func stop() -> Bool {
        stopHasRun = true
        return true
    }
    
    public var releaseHasRun: Bool = false
    public func release() {
        releaseHasRun = true
    }
}

