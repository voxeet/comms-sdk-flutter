import Foundation

enum ConferenceServiceAssertUtils {
    
    static func assertConference(args: [String: Any], mockConference: VTConference?) throws {
        try (args["id"] as? String).map {
            try nativeAssertEquals(mockConference?.id, $0)
        }
        try (args["alias"] as? String).map {
            try nativeAssertEquals(mockConference?.alias, $0)
        }
        try (args["isNew"] as? Bool).map {
            try nativeAssertEquals(mockConference?.isNew, $0)
        }
        try (args["participants_0"] as? [String: Any]).map {
            try assertParticipant(args: $0, mockArgs: mockConference?.participants[0])
        }
        
        try (args["params"] as? [String: Any]).map {
            try assertConferenceParameters(
                args: $0, mockConferenceParameters: mockConference?.params
            )
        }

        try (args["permissions"] as? [Int]).map {
            try assertConferencePermissions(args: $0, mockPermissions: mockConference?.permissions)
        }
        
        try (args["status"] as? String).map {
            try nativeAssertEquals(mockConference?.status.rawValue, Int($0))
        }

        try (args["pinCode"] as? String).map {
            try nativeAssertEquals(mockConference?.pinCode, $0)
        }
    }
    
    static func assertParticipant(args: [String: Any], mockArgs: VTParticipant?) throws {
        
        // TODO: implement this
        
        try ifKeyExists(arg: args, key: "id") { (value: String) in
            try nativeAssertEquals(mockArgs?.id, value);
        }

        try ifKeyExists(arg: args, key: "participantInfo") {(value:[String: Any]) in
            try ifKeyExists(arg: args, key: "externalId") { (value: String) in
                try nativeAssertEquals(mockArgs?.info.externalID, value, msg: "External id is incorrect")
            }
            try ifKeyExists(arg: args, key: "name") { (value: String) in
                try nativeAssertEquals(mockArgs?.info.name, value, msg: "name is incorrect")
            }
            try ifKeyExists(arg: args, key: "avatarURL") { (value:String) in
                try nativeAssertEquals(mockArgs?.info.avatarURL, value, msg: "avatar url is incorrect")
            }  
        }       

//            try (args["type"] as? <# type #>).map {
//                try nativeAssertEquals(mockArgs?.<# property #>, $0)
//            }
//            try (args["status"] as? <# type #>).map {
//                try nativeAssertEquals(mockArgs?.<# property #>, $0)
//            }
//            try (args["streams"] as? <# type #>).map {
//                try nativeAssertEquals(mockArgs?.<# property #>, $0)
//            }
//            try (args["audioReceivingFrom"] as? <# type #>).map {
//                try nativeAssertEquals(mockArgs?.<# property #>, $0)
//            }
//            try (args["audioTransmitting"] as? <# type #>).map {
//                try nativeAssertEquals(mockArgs?.<# property #>, $0)
//            }
    }
    
    static func assertConferenceParameters(
        args: [String: Any],
        mockConferenceParameters: VTConferenceParameters?
    ) throws {
        // TODO: implement this
    }
    
    static func assertConferencePermissions(args: [Int], mockPermissions: [VTConferencePermission]?) throws {
        for (index, arg) in args.enumerated() {
            try assertConferencePermission(args: arg, mockPermission: mockPermissions?[index])
        }
    }
    
    static func assertConferencePermission(args: Int, mockPermission: VTConferencePermission?) throws {
        try nativeAssertEquals(mockPermission?.rawValue, args)
    }
    
    static func assertParticipantPermissions(args: [String: Any], mockPermissions: VTParticipantPermissions?) throws {
        try ifKeyExists(arg: args, key: "participant", closure: { (args: [String: Any]) in
            try assertParticipant(args: args, mockArgs: mockPermissions?.participant)
        })
        
        try ifKeyExists(arg: args, key: "permissions", closure: { (args: [Int]) in
            try assertConferencePermissions(args: args, mockPermissions: mockPermissions?.permissions)
        })
    }
    
    static func assertJoinOptions(args: [String: Any], mockJoinOptions: VTJoinOptions?) throws {
        try ifKeyExists(arg: args, key: "conferenceAccessToken", closure: { arg in
            try nativeAssertEquals(mockJoinOptions?.conferenceAccessToken, arg)
        })
        try ifKeyExists(arg: args, key: "constraints", closure: { (arg: [String: Any]) in
            try ifKeyExists(arg: arg, key: "audio", closure: { (arg: NSNumber) in
                try nativeAssertEquals(mockJoinOptions?.constraints.audio, Bool(truncating: arg))
            })
            try ifKeyExists(arg: arg, key: "video", closure: { (arg: NSNumber) in
                try nativeAssertEquals(mockJoinOptions?.constraints.video, Bool(truncating: arg))
            })
        })
        try ifKeyExists(arg: args, key: "maxVideoForwarding", closure: { (arg: NSNumber) in
            try nativeAssertEquals(mockJoinOptions?.maxVideoForwarding, arg)
        })
        // TODO: clarify if following values are actually used
        // In react native these values are not converted to native values
//        try ifKeyExists(arg: args, key: "mixing", closure: { arg in
//            try nativeAssertEquals(mockJoinOptions?.mixing, arg)  // This is actually an object
//        })
//        try ifKeyExists(arg: args, key: "preferRecvMono", closure: { arg in
//            try nativeAssertEquals(mockJoinOptions?.preferRecvMono, arg)
//        })
//        try ifKeyExists(arg: args, key: "preferSendMono", closure: { arg in
//            try nativeAssertEquals(mockJoinOptions?.preferSendMono, arg)
//        })
//        try ifKeyExists(arg: args, key: "simulcast", closure: { arg in
//            try nativeAssertEquals(mockJoinOptions?.simulcast, arg)
//        })
        try ifKeyExists(arg: args, key: "spatialAudio", closure: { (arg: NSNumber) in
            try nativeAssertEquals(mockJoinOptions?.spatialAudio, Bool(truncating: arg))
        })
    }

    static func assertSpatialPosition(args: [String: Any], mockArgs: VTSpatialPosition?) throws {
        
        try ifKeyExists(arg: args, key: "x") { (value: Double) in
            try nativeAssertEquals(mockArgs?.x, value);
        }
        
        try ifKeyExists(arg: args, key: "y") { (value: Double) in
            try nativeAssertEquals(mockArgs?.y, value);
        }
        
        try ifKeyExists(arg: args, key: "z") { (value: Double) in
            try nativeAssertEquals(mockArgs?.z, value);
        }
    }
    
    static func assertSpatialScale(args: [String: Any], mockArgs: VTSpatialScale?) throws {
        
        try ifKeyExists(arg: args, key: "x") { (value: Double) in
            try nativeAssertEquals(mockArgs?.x, value);
        }
        
        try ifKeyExists(arg: args, key: "y") { (value: Double) in
            try nativeAssertEquals(mockArgs?.y, value);
        }
        
        try ifKeyExists(arg: args, key: "z") { (value: Double) in
            try nativeAssertEquals(mockArgs?.z, value);
        }
    }
    
    static func assertSpatialDirection(args: [String: Any], mockArgs: VTSpatialDirection?) throws {
        
        try ifKeyExists(arg: args, key: "x") { (value: Double) in
            try nativeAssertEquals(mockArgs?.x, value);
        }
        
        try ifKeyExists(arg: args, key: "y") { (value: Double) in
            try nativeAssertEquals(mockArgs?.y, value);
        }
        
        try ifKeyExists(arg: args, key: "z") { (value: Double) in
            try nativeAssertEquals(mockArgs?.z, value);
        }
    }
    
    static func assertAudioProcessing(args: [String: Any], mockArgs: Bool?) throws {
        try ifKeyExists(arg: args, key: "value", closure: { (expectedValue: Bool) in
            try nativeAssertEquals(mockArgs, expectedValue)
        })
    }
    
    static func assertListenOptions(args: [String: Any], mockListenOptions: VTListenOptions?) throws {
        try ifKeyExists(arg: args, key: "conferenceAccessToken", closure: { arg in
            try nativeAssertEquals(mockListenOptions?.conferenceAccessToken, arg)
        })
        try ifKeyExists(arg: args, key: "maxVideoForwarding", closure: { (arg: NSNumber) in
            try nativeAssertEquals(mockListenOptions?.maxVideoForwarding, arg)
        })
        try ifKeyExists(arg: args, key: "spatialAudio", closure: { (arg: NSNumber) in
            try nativeAssertEquals(mockListenOptions?.spatialAudio, Bool(truncating: arg))
        })
    }

    
    static func createVTConference(type: Int?) throws -> VTConference {
        switch type {
            
        case 1:
            return {
                let conference = VTConference()
                conference.mockIdValue = "setCreateConferenceReturn_id_1"
                conference.mockAliasValue = "setCreateConferenceReturn_alias_1"
                return conference
            }()
            
        case 2:
            return {
                let conference = VTConference()
                conference.mockIdValue = "setCreateConferenceReturn_id_2"
                conference.mockAliasValue = "setCreateConferenceReturn_alias_2"
                conference.isNew = true
                conference.participants = [
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_2"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_2",
                            name: "participant_info_name_2",
                            avatarURL: "participant_info_avatar_url_2"
                        )
                        participant.type = .listener
                        participant.status = .decline
                        participant.audioReceivingFrom = true
                        participant.audioTransmitting = true
                        return participant
                    }()
                ]
                conference.params.liveRecording = true
                conference.params.rtcpMode = "worst"
                conference.params.stats = true
                conference.params.ttl =  30
                conference.params.videoCodec = "VP8"
                conference.params.dolbyVoice = true
                conference.params.audioOnly = true
                conference.permissions = [.stream]
                conference.status = .created
                conference.pinCode = "1234"
                return conference
            }()
            
        case 3:
            return {
                let conference = VTConference()
                conference.mockIdValue = "setCreateConferenceReturn_id_3"
                conference.mockAliasValue = "setCreateConferenceReturn_alias_3"
                conference.isNew = false
                conference.participants = [
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_3"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_3",
                            name: "participant_info_name_3",
                            avatarURL: "participant_info_avatar_url_3"
                        )
                        participant.type = .user
                        participant.status = .error
                        participant.audioReceivingFrom = false
                        participant.audioTransmitting = false
                        return participant
                    }()
                ]
                conference.params.liveRecording = false
                conference.params.rtcpMode = "best"
                conference.params.stats = false
                conference.params.ttl =  15
                conference.params.videoCodec = "H264"
                conference.params.dolbyVoice = false
                conference.params.audioOnly = false
                conference.permissions = [.join]
                conference.status = .ended
                conference.pinCode = "1234"
                return conference
            }()
            
        case 4:
            return {
                let conference = VTConference()
                conference.mockIdValue = "setCreateConferenceReturn_id_4"
                conference.mockAliasValue = "setCreateConferenceReturn_alias_4"
                conference.participants = [
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_4"
                        return participant
                    }()
                ]
                return conference
            }()
            
        case 5:
            return {
                let conference = VTConference()
                conference.mockIdValue = "setCreateConferenceReturn_id_5"
                conference.mockAliasValue = "setCreateConferenceReturn_alias_5"
                conference.isNew = true
                conference.participants = [
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_5_1"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_5_1",
                            name: "participant_info_name_2",
                            avatarURL: "participant_info_avatar_url_5_1"
                        )
                        participant.type = .listener
                        participant.status = .decline
                        participant.audioReceivingFrom = true
                        participant.audioTransmitting = true
                        return participant
                    }(),
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_5_2"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_5_2",
                            name: "participant_info_name_2",
                            avatarURL: "participant_info_avatar_url_5_2"
                        )
                        participant.type = .listener
                        participant.status = .connected
                        participant.audioReceivingFrom = true
                        participant.audioTransmitting = true
                        return participant
                    }()
                ]
                conference.params.liveRecording = true
                conference.params.rtcpMode = "worst"
                conference.params.stats = true
                conference.params.ttl =  30
                conference.params.videoCodec = "VP8"
                conference.params.dolbyVoice = true
                conference.params.audioOnly = true
                conference.permissions = [.stream]
                conference.status = .created
                conference.pinCode = "1234"
                return conference
            }()

        case 6:
            return {
                let conference = VTConference()
                conference.mockIdValue = "setCreateConferenceReturn_id_6"
                conference.mockAliasValue = "setCreateConferenceReturn_alias_6"
                conference.isNew = true
                conference.participants = [
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_6_1"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_6_1",
                            name: "participant_info_name_2",
                            avatarURL: "participant_info_avatar_url_6_1"
                        )
                        participant.type = .listener
                        participant.status = .connected
                        participant.audioReceivingFrom = true
                        participant.audioTransmitting = true
                        return participant
                    }(),
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_6_2"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_6_2",
                            name: "participant_info_name_2",
                            avatarURL: "participant_info_avatar_url_6_2"
                        )
                        participant.type = .listener
                        participant.status = .inactive
                        participant.audioReceivingFrom = true
                        participant.audioTransmitting = true
                        return participant
                    }(),
                    {
                        let participant = VTParticipant()
                        participant.id = "participant_id_6_3"
                        participant.info = VTParticipantInfo(
                            externalID: "participant_info_external_id_6_3",
                            name: "participant_info_name_3",
                            avatarURL: "participant_info_avatar_url_6_3"
                        )
                        participant.type = .listener
                        participant.status = .kicked
                        participant.audioReceivingFrom = true
                        participant.audioTransmitting = true
                        return participant
                    }()
                ]
                conference.params.liveRecording = true
                conference.params.rtcpMode = "worst"
                conference.params.stats = true
                conference.params.ttl =  30
                conference.params.videoCodec = "VP8"
                conference.params.dolbyVoice = true
                conference.params.audioOnly = true
                conference.permissions = [.stream]
                conference.status = .destroyed
                conference.pinCode = "1234"
                return conference
            }()


        default:
            break
        }
        try nativeFail(msg: "Could not create a converence of type: \(String(describing: type))")
        return VTConference()
    }

    static func createVTParticipant(args: [String: Any]) throws -> VTParticipant {
        let participant = VTParticipant()
        participant.id = args["id"] as? String

        return participant
    }
}
