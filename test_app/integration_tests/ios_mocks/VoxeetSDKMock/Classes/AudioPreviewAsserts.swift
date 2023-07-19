import Foundation

public class AudioPreviewAsserts {
    
    private static var instance: AudioPreviewAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?
    
    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.AudioPreviewAsserts"
        )
    }

    private func getStatus(args: [String: Any]) throws {
        VoxeetSDK.shared.audio.local.preview.statusReturn = recorderStatuses.reversed()
    }

    private func assertStatusArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.audio.local.preview.statusHasRunCounter
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun > 0, hasRun)
        }
    }
    
    private func getCaptureMode(args: [String: Any]) throws {
        let preview = VoxeetSDK.shared.audio.local.preview
        preview.captureModeReturn = [
            AudioCaptureMode.unprocessed(),
        ]
        for voicFont in voiceFonts {
            for noiseRecuction in noiseReductions {
                preview.captureModeReturn.append(
                    AudioCaptureMode.standard(noiseReduction: noiseRecuction, voiceFont: voicFont)
                )
            }
        }
        preview.captureModeReturn.reverse()
    }

    private func assertGetCaptureModeArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.audio.local.preview.captureModeGetterRunCounter
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun > 0, hasRun)
        }
    }
    
    private func setCaptureMode(args: [String: Any]) throws {
        VoxeetSDK.shared.audio.local.preview.captureModeSetterArgs = []
    }

    private func assertSetCaptureModeArgs(args: [String: Any]) throws {
        var mockArgs = VoxeetSDK.shared.audio.local.preview.captureModeSetterArgs
        mockArgs.reverse()
        var captureMode = mockArgs.popLast()
        try nativeAssertEquals(captureMode is UnprocessedAudioCaptureMode, true)

        for voicFont in voiceFonts {
            for noiseRecuction in noiseReductions {
                captureMode = mockArgs.popLast()
                try nativeAssertEquals(captureMode is StandardAudioCaptureMode, true)
                guard let standardCaputureMode = captureMode as? StandardAudioCaptureMode else {
                    try nativeFail(msg: "Capture mode is not standard")
                    return
                }
                try nativeAssertEquals(standardCaputureMode.noiseReduction, noiseRecuction)
                try nativeAssertEquals(standardCaputureMode.voiceFont, voicFont)
            }
        }
    }
    
    private func record(args: [String: Any]) throws {
        VoxeetSDK.shared.audio.local.preview.recordArgs = []
        VoxeetSDK.shared.audio.local.preview.recordReturnError = [nil, nil]
    }

    private func assertRecordArgs(args: [String: Any]) throws {
        var mockArgs = VoxeetSDK.shared.audio.local.preview.recordArgs
        mockArgs.reverse()
        var duration = mockArgs.popLast()
        try nativeAssertEquals(duration, 1)
        duration = mockArgs.popLast()
        try nativeAssertEquals(duration, 10)
    }

    private func play(args: [String: Any]) throws {
        VoxeetSDK.shared.audio.local.preview.playArgs = []
        VoxeetSDK.shared.audio.local.preview.playReturnError = [nil, nil]
    }

    private func assertPlayArgs(args: [String: Any]) throws {
        var mockArgs = VoxeetSDK.shared.audio.local.preview.playArgs
        mockArgs.reverse()
        var loop = mockArgs.popLast()
        try nativeAssertEquals(loop, true)
        loop = mockArgs.popLast()
        try nativeAssertEquals(loop, false)
    }

    private func cancel(args: [String: Any]) throws {
        VoxeetSDK.shared.audio.local.preview.cancelHasRun = false
    }

    private func assertCancelArgs(args: [String: Any]) throws {
        var mockArgs = VoxeetSDK.shared.audio.local.preview.cancelHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockArgs, hasRun)
        }
    }

    private func release(args: [String: Any]) throws {
        VoxeetSDK.shared.audio.local.preview.releaseHasRun = false
    }

    private func assertReleaseArgs(args: [String: Any]) throws {
        var mockArgs = VoxeetSDK.shared.audio.local.preview.releaseHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockArgs, hasRun)
        }
    }
    
    
    private func emitStatusChangedEvents(args: [String: Any]) throws {
        let onStatusChangedClosure = VoxeetSDK.shared.audio.local.preview.onStatusChanged
        let queue = DispatchQueue(label: "conference.asserts.test.queue")
        
        var statuses = recorderStatuses
        statuses.reverse()
        var sendStatusWithDelay: (() -> Void)?
        sendStatusWithDelay = {
            queue.asyncAfter(deadline: .now() + 0.1) {
                guard let status = statuses.popLast() else {
                    return
                }
                onStatusChangedClosure?(status)
                sendStatusWithDelay?()
            }
        }
        
        queue.asyncAfter(deadline: .now() + 1.5) {
            sendStatusWithDelay?()
        }
    }
}

extension AudioPreviewAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {

            case "getStatus": try getStatus(args: args)
            case "assertStatusArgs": try assertStatusArgs(args: args)
                
            case "getCaptureMode": try getCaptureMode(args: args)
            case "assertGetCaptureModeArgs": try assertGetCaptureModeArgs(args: args)
                
            case "setCaptureMode": try setCaptureMode(args: args)
            case "assertSetCaptureModeArgs": try assertSetCaptureModeArgs(args: args)

            case "record": try record(args: args)
            case "assertRecordArgs": try assertRecordArgs(args: args)
                
            case "play": try play(args: args)
            case "assertPlayArgs": try assertPlayArgs(args: args)
                
            case "cancel": try cancel(args: args)
            case "assertCancelArgs": try assertCancelArgs(args: args)
                
            case "release": try release(args: args)
            case "assertReleaseArgs": try assertReleaseArgs(args: args)
                
            case "emitStatusChangedEvents": try emitStatusChangedEvents(args: args)

            default: throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

private let recorderStatuses: [RecorderStatus] = [
    .noRecordingAvailable, .recordingAvailable, .recording, .playing, .released
]

private let voiceFonts: [VoiceFont] = [
    .none,
    .masculine,
    .feminine,
    .helium,
    .darkModulation,
    .brokenRobot,
    .interference,
    .abyss,
    .wobble,
    .starshipCaptain,
    .nervousRobot,
    .swarm,
    .amRadio,
]

private let noiseReductions: [StandardAudioCaptureMode.NoiseReduction] = [
    .high, .low
]
