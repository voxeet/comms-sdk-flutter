import Foundation
import WebRTC

public class ConferenceServiceAsserts {
    
    private static var instance: ConferenceServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?

    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.ConferenceServiceAsserts"
        )
    }
    
    private func setCreateConferenceReturn(args: [String: Any]) throws {
        VoxeetSDK.shared.conference.createReturn
            = try ConferenceServiceAssertUtils.createVTConference(type: args["type"] as? Int)
    }

    private func assertCreateConferenceArgs(args: [String: Any]) throws {
        let createArgs = VoxeetSDK.shared.conference.createArgs
        try (args["alias"] as? String).map {
            try nativeAssertEquals(createArgs?.alias, $0, msg: "Alias is incorrect")
        }
        try (args["params_dolby"] as? Bool).map {
            try nativeAssertEquals(createArgs?.params.dolbyVoice, $0, msg: "DolbyVoice is incorrect")
        }
        try (args["params_liveRecording"] as? Bool).map {
            try nativeAssertEquals(createArgs?.params.liveRecording, $0, msg: "LiveRecording is incorrect")
        }
        try (args["params_rtcpMode"] as? String).map {
            try nativeAssertEquals(createArgs?.params.rtcpMode, $0, msg: "RtcpMode is incorrect")
        }
        try (args["params_ttl"] as? NSNumber).map {
            try nativeAssertEquals(createArgs?.params.ttl, $0, msg: "TTL is incorrect")
        }
        try (args["params_videoCodec"] as? String).map {
            try nativeAssertEquals(createArgs?.params.videoCodec, $0, msg: "VideoCodec is incorrect")
        }
        try (args["pin"] as? NSNumber).map {
            try nativeAssertEquals(createArgs?.pinCode, $0, msg: "Pin is incorrect")
        }
        try (args["spatialAudioStyle"] as? SpatialAudioStyle).map {
            try nativeAssertEquals(createArgs?.spatialAudioStyle, $0, msg: "SpatialAudioStyle is incorrect")
        }
    }

    private func setFetchConferenceReturn(args: [String: Any]) throws {
        VoxeetSDK.shared.conference.fetchReturn
            = try ConferenceServiceAssertUtils.createVTConference(type: args["type"] as? Int)
    }
    
    private func assertFetchConferenceArgs(args: [String: Any]) throws {
        let fetchArgs = VoxeetSDK.shared.conference.fetchArgs
        try (args["conferenceId"] as? String).map {
            try nativeAssertEquals(fetchArgs, $0)
        }
    }
    
    private func setJoinConferenceReturn(args: [String: Any]) throws {
        VoxeetSDK.shared.conference.joinReturn =
            try ConferenceServiceAssertUtils.createVTConference(type: args["type"] as? Int)
    }
    
    private func assertJoinConfrenceArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.joinArgs
        try ifKeyExists(arg: args, key: "conference") { args in
            try ConferenceServiceAssertUtils.assertConference(
                args: args, mockConference: mockArgs?.conference
            )
        }
        try ifKeyExists(arg: args, key: "joinOptions") { args in
            try ConferenceServiceAssertUtils.assertJoinOptions(
                args: args, mockJoinOptions: mockArgs?.options
            )
        }
    }
        
    private func assertKickArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.kickArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func assertReplayArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.replayArgs
        try ifKeyExists(arg: args, key: "conference") { args in
            try ConferenceServiceAssertUtils.assertConference(
                args: args, mockConference: mockArgs?.conference
            )
        }
        try (args["offset"] as? Int).map {
            try nativeAssertEquals(mockArgs?.replayOptions?.offset, $0, msg: "offset is incorrect")
        }
        try (args["conferenceAccessToken"] as? String?).map {
            try nativeAssertEquals(mockArgs?.replayOptions?.conferenceAccessToken, $0, msg: "conferenceAccessToken is incorrect")
        }
    }
    
    private func setCurrentConference(args: [String: Any]) throws {
        if let type = args["type"] as? Int {
            VoxeetSDK.shared.conference.current
                = try ConferenceServiceAssertUtils.createVTConference(type: type)
            return
        }
        if let for_current = args["for_current"] as? Bool, for_current {
            let conferenceService = VoxeetSDK.shared.conference
            conferenceService.currentUseList = true
            conferenceService.currentReturn.append(nil)
            for alias in ["alias_1", "alias_2"] {
                for confId in ["conf_id_1", "conf_id_2"] {
                    for isNew in [false, true] {
                        for status in confereceStatusList {
                            for spatialAudioStyle in spatialAudioStyleList {
                                let conference = VTConference()
                                conference.mockAliasValue = alias
                                conference.mockIdValue = confId
                                conference.isNew = isNew
                                conference.status = status
                                conference.spatialAudioStyle = spatialAudioStyle
                                conferenceService.currentReturn.append(conference)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func assertLeaveArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.leaveHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockArgs, hasRun)
        }
    }
    
    private func setAudioLevelReturn(args: [String: Any]) throws {
        try ifKeyExists(arg: args, key: "value", closure: { (value: NSNumber) in
            VoxeetSDK.shared.conference.audioLevelReturn = value.floatValue
        })
    }
    
    private func assertAudioLevelArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.audioLevelArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func setMaxVideoForwardingReturn(args: [String: Any]) throws {
        try ifKeyExists(arg: args, key: "value", closure: { (value: NSNumber) in
            VoxeetSDK.shared.conference.maxVideoForwardingReturn = value.intValue
        })
    }

    private func setStartAudioConferenceReturn(args: [String: Any]) throws {
       // VoxeetSDK.shared.conference.startAudioReturn = createVTConference(type: args["type" as? Int])
    }

    private func assertStartAudioConferenceArgs(args: [String:Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.startAudioArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func setStopAudioConferenceReturn(args: [String: Any]) throws {
       // VoxeetSDK.shared.conference.stopAudioReturn = createVTConference(type: args["type" as? Int])
    }

    private func assertStopAudioConferenceArgs(args: [String:Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.stopAudioArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func setStartVideoConferenceReturn(args: [String: Any]) throws {
       // VoxeetSDK.shared.conference.startVideoReturn = createVTConference(type: args["type" as? Int])
    }

    private func assertStartVideoConferenceArgs(args: [String:Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.startVideoArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func setStopVideoConferenceReturn(args: [String: Any]) throws {
       // VoxeetSDK.shared.conference.stopVideoReturn = createVTConference(type: args["type" as? Int])
    }

    private func assertStopVideoConferenceArgs(args: [String:Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.stopVideoArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs)
    }

    private func assertStartScreeenShareArgs(args: [String:Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.startScreenShareArgs
        try ifKeyExists(arg: args, key: "broadcast") { (broadcast: Bool) in
            try nativeAssertEquals(mockArgs, broadcast)
        }
    }

    private func assertStopScreeenShareArgs(args: [String:Any]) throws {}

    private func assertSetSpatialPositionArgs(args: [String: Any]) throws {
        let mockParticipant = VoxeetSDK.shared.conference.spatialPositionArgs?.participant
        try ifKeyExists(arg: args, key: "participant") { (participant: [String: Any]) in
            try ConferenceServiceAssertUtils.assertParticipant(args: participant, mockArgs: mockParticipant)
        }
        let mockPosition = VoxeetSDK.shared.conference.spatialPositionArgs?.position
        try ifKeyExists(arg: args, key: "position") { (position: [String: Any]) in
            try ConferenceServiceAssertUtils.assertSpatialPosition(args: position, mockArgs: mockPosition)
        }
    }

    private func assertSetSpatialDirectionArgs(args: [String: Any]) throws {
        let mockParticipant = VoxeetSDK.shared.conference.spatialDirectionArgs?.participant
        try ifKeyExists(arg: args, key: "participant") { (participant: [String: Any]) in
            try ConferenceServiceAssertUtils.assertParticipant(args: participant, mockArgs: mockParticipant)
        }
        let mockDirection = VoxeetSDK.shared.conference.spatialDirectionArgs?.direction
        try ifKeyExists(arg: args, key: "direction") { (direction: [String: Any]) in
            try ConferenceServiceAssertUtils.assertSpatialDirection(args: direction, mockArgs: mockDirection)
        }
    }

    private func assertSetSpatialEnvironmentArgs(args: [String: Any]) throws {
        let mockScale = VoxeetSDK.shared.conference.spatialEnvironmentArgs?.scale
        try ifKeyExists(arg: args, key: "scale") { (scale: [String: Any]) in
            try ConferenceServiceAssertUtils.assertSpatialScale(args: scale, mockArgs: mockScale)
        }
        let mockForward = VoxeetSDK.shared.conference.spatialEnvironmentArgs?.forward
        try ifKeyExists(arg: args, key: "forward") { (position: [String: Any]) in
            try ConferenceServiceAssertUtils.assertSpatialPosition(args: position, mockArgs: mockForward)
        }
        let mockUp = VoxeetSDK.shared.conference.spatialEnvironmentArgs?.up
        try ifKeyExists(arg: args, key: "up") { (position: [String: Any]) in
            try ConferenceServiceAssertUtils.assertSpatialPosition(args: position, mockArgs: mockUp)
        }
        let mockRight = VoxeetSDK.shared.conference.spatialEnvironmentArgs?.right
        try ifKeyExists(arg: args, key: "right") { (position: [String: Any]) in
            try ConferenceServiceAssertUtils.assertSpatialPosition(args: position, mockArgs: mockRight)
        }
    }
    
    private func assertMuteConferenceArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.muteArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockArgs?.participant)
        try ifKeyExists(arg: args, key: "isMuted") { (isMuted: Bool) in
            try nativeAssertEquals(mockArgs?.isMuted, isMuted)
        }
    }
    
    private func setIsMuted(args: [String: Any]) throws {
        try ifKeyExists(arg: args, key: "isMuted", closure: { (isMuted: Bool) in
            VoxeetSDK.shared.conference.isMutedReturn = isMuted
        })
    }
    
    private func assertMuteOutputArgs(args: [String: Any]) throws {
        let muteMockArgs = VoxeetSDK.shared.conference.muteOutputArgs
        try ifKeyExists(arg: args, key: "isMuted") { (isMuted: Bool) in
            try nativeAssertEquals(muteMockArgs, isMuted)
        }
    }
    
    private func emitParticipantUpdatedEvents(args: [String: Any]) throws {
        let delegate = VoxeetSDK.shared.conference.delegate
        let conference = try ConferenceServiceAssertUtils.createVTConference(type: 6)
        let queue = DispatchQueue(label: "conference.asserts.test.queue")
        queue.asyncAfter(deadline: .now() + 2) {
            delegate?.participantAdded(participant: conference.participants[0])
            queue.asyncAfter(deadline: .now() + 0.5) {
                delegate?.participantAdded(participant: conference.participants[1])
                queue.asyncAfter(deadline: .now() + 0.5) {
                    delegate?.participantUpdated(participant: conference.participants[0])
                }
            }
        }
    }
    
    private func emitStreamsChangedEvents(args: [String: Any]) throws {
        let delegate = VoxeetSDK.shared.conference.delegate
        let conference = try ConferenceServiceAssertUtils.createVTConference(type: 6)
        let queue = DispatchQueue(label: "conference.asserts.test.queue")
        queue.asyncAfter(deadline: .now() + 5) {
            delegate?.streamAdded(
                participant: conference.participants[0],
                stream: MediaStream(
                    streamId: "stream_id_1",
                    type: .Camera,
                    audioTracks: [
                        AudioTrack(trackId: "audio_track_1"),
                        AudioTrack(trackId: "audio_track_2")
                    ],
                    videoTracks: [
                        VideoTrack(trackId: "video_track_1"),
                        VideoTrack(trackId: "video_track_2")
                    ]
                )
            )
            queue.asyncAfter(deadline: .now() + 0.5) {
                delegate?.streamUpdated(
                    participant: conference.participants[1],
                    stream: MediaStream(
                        streamId: "stream_id_2",
                        type: .Custom,
                        audioTracks: [
                            AudioTrack(trackId: "audio_track_1"),
                            AudioTrack(trackId: "audio_track_2")
                        ],
                        videoTracks: [
                            VideoTrack(trackId: "video_track_1"),
                            VideoTrack(trackId: "video_track_2")
                        ]
                    )
                )
                queue.asyncAfter(deadline: .now() + 0.5) {
                    delegate?.streamRemoved(
                        participant: conference.participants[2],
                        stream: MediaStream(
                            streamId: "stream_id_3",
                            type: .Custom,
                            audioTracks: [
                                AudioTrack(trackId: "audio_track_1"),
                                AudioTrack(trackId: "audio_track_2")
                            ],
                            videoTracks: [
                                VideoTrack(trackId: "video_track_1"),
                                VideoTrack(trackId: "video_track_2")
                            ]
                        )
                    )
                }
            }
        }
    }
    
    private func setIsSpeaking(args: [String: Any]) throws {
        try ifKeyExists(arg: args, key: "isSpeaking", closure: { (isSpeaking: Bool) in
            VoxeetSDK.shared.conference.speakingReturn = isSpeaking
        })
    }
    
    private func assertIsSpeaking(args: [String: Any]) throws {
        let mockParticipant = VoxeetSDK.shared.conference.speakingArgs
        try ConferenceServiceAssertUtils.assertParticipant(args: args, mockArgs: mockParticipant)
    }

    private func assertSetMaxVideoForwardingArgs(args: [String:Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.videoForwardingArgs

        try ifKeyExists(arg: args, key: "max") { (max: Int) in
            try nativeAssertEquals(mockArgs?.max, max, msg: "max is incorrect")
        }
        try (args["prioritizedParticipants"] as? [[String: Any]]).map { participants in
            try ConferenceServiceAssertUtils.assertParticipant(args: participants.first ?? [:], mockArgs: mockArgs?.participants?.first)
        }
    }
    
    private func assertSetAudioProcessing(args: [String: Any]) throws {
        let mockAudioProcessing = VoxeetSDK.shared.conference.audioProcessingArgs
        try ConferenceServiceAssertUtils.assertAudioProcessing(args: args, mockArgs: mockAudioProcessing)
    }
    
    private func assertUpdatePermissions(args: [String: Any]) throws {
        let mockPermissions = VoxeetSDK.shared.conference.updatePermissionsArgs
        try ifKeyExists(arg: args, key: "updatePermissions", closure: { (args: [[String: Any]] ) in
            for (index, arg) in args.enumerated() {
                try ConferenceServiceAssertUtils.assertParticipantPermissions(
                    args: arg, mockPermissions: mockPermissions?[index]
                )
            }
        })
    }
    
    private func setListenConferenceReturn(args: [String: Any]) throws {
        VoxeetSDK.shared.conference.listenReturn =
            try ConferenceServiceAssertUtils.createVTConference(type: args["type"] as? Int)
    }
    
    private func assertListenConfrenceArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.conference.listenArgs
        try ifKeyExists(arg: args, key: "conference") { args in
            try ConferenceServiceAssertUtils.assertConference(
                args: args, mockConference: mockArgs?.conference
            )
        }
        try ifKeyExists(arg: args, key: "listenOptions") { args in
            try ConferenceServiceAssertUtils.assertListenOptions(
                args: args, mockListenOptions: mockArgs?.options
            )
        }
    }
}

extension ConferenceServiceAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
                
            case "setCreateConferenceReturn":
                try setCreateConferenceReturn(args: args)
                
            case "assertCreateConferenceArgs":
                try assertCreateConferenceArgs(args: args)
                
            case "setFetchConferenceReturn":
                try setFetchConferenceReturn(args: args)
                
            case "assertFetchConferenceArgs":
                try assertFetchConferenceArgs(args: args)
                
            case "setJoinConferenceReturn":
                try setJoinConferenceReturn(args: args)
                
            case "assertJoinConfrenceArgs":
                try assertJoinConfrenceArgs(args: args)
            
            case "setStartAudioConferenceReturn":
                try setStartAudioConferenceReturn(args: args)

            case "assertStartAudioConferenceArgs":
                try assertStartAudioConferenceArgs(args: args)
            
            case "setStopAudioConferenceReturn":
                try setStopAudioConferenceReturn(args: args)

            case "assertStopAudioConferenceArgs":
                try assertStopAudioConferenceArgs(args: args)

            case "setStartVideoConferenceReturn":
                try setStartVideoConferenceReturn(args: args)

            case "assertStartVideoConferenceArgs":
                try assertStartVideoConferenceArgs(args: args)
            
            case "setStopVideoConferenceReturn":
                try setStopVideoConferenceReturn(args: args)

            case "assertStopVideoConferenceArgs":
                try assertStopVideoConferenceArgs(args: args)

            case "assertStartScreeenShareArgs":
                try assertStartScreeenShareArgs(args: args)

            case "assertStopScreeenShareArgs":
                try assertStopScreeenShareArgs(args: args)

            case "assertKickArgs":
                try assertKickArgs(args: args)

            case "assertReplayConferenceArgs":
                try assertReplayArgs(args: args)
            
            case "setCurrentConference":
                try setCurrentConference(args: args)
                
            case "assertLeaveArgs":
                try assertLeaveArgs(args: args)
                
            case "setAudioLevelReturn":
                try setAudioLevelReturn(args: args)
                
            case "assertAudioLevelArgs":
                try assertAudioLevelArgs(args: args)
                
            case "setMaxVideoForwardingReturn":
                try setMaxVideoForwardingReturn(args: args)

            case "assertSetSpatialPositionArgs":
                try assertSetSpatialPositionArgs(args: args)
                
            case "assertSetSpatialDirectionArgs":
                try assertSetSpatialDirectionArgs(args: args)
                
            case "assertSetSpatialEnvironmentArgs":
                try assertSetSpatialEnvironmentArgs(args: args)
            
            case "assertMuteConferenceArgs":
                try assertMuteConferenceArgs(args: args)
            
            case "setIsMuted":
                try setIsMuted(args: args)
            
            case "assertMuteOutputArgs":
                try assertMuteOutputArgs(args: args)
                
            case "emitParticipantUpdatedEvents":
                try emitParticipantUpdatedEvents(args: args)
                
            case "emitStreamsChangedEvents":
                try emitStreamsChangedEvents(args: args)
            
            case "setIsSpeaking":
                try setIsSpeaking(args: args)
                
            case "assertIsSpeaking":
                try assertIsSpeaking(args: args)
            
            case "assertSetAudioProcessing":
                try assertSetAudioProcessing(args: args)

            case "assertSetMaxVideoForwardingArgs":
                try assertSetMaxVideoForwardingArgs(args: args)
                
            case "assertUpdatePermissions":
                try assertUpdatePermissions(args: args)
            
            case "setListenConferenceReturn":
                try setListenConferenceReturn(args: args)
            
            case "assertListenConfrenceArgs":
                try assertListenConfrenceArgs(args: args)

            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

private let confereceStatusList: [VTConferenceStatus] = [
    .created, .creating, .destroyed, .ended, .error, .joined, .joining, .leaving, .left,
];

private let spatialAudioStyleList: [SpatialAudioStyle?] = [nil, .individual, .shared, .disabled]
