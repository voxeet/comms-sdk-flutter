import Foundation
import VoxeetSDK
import WebRTC

// MARK: - Supported Events
private enum EventKeys: String, CaseIterable {
    /// Emitted when a new participant is invited to a conference or joins a conference.
    case participantAdded = "EVENT_CONFERENCE_PARTICIPANT_ADDED"
    /// Emitted when a participant changes VTConferenceStatus.
    case participantUpdated = "EVENT_CONFERENCE_PARTICIPANT_UPDATED"
    /// Emitted when the local participant"s permissions are updated.
    case permissionsUpdated = "EVENT_CONFERENCE_PERMISSIONS_UPDATED"
    /// Emitted when ta conference changes status.
    case statusUpdated = "EVENT_CONFERENCE_STATUS_UPDATED"
    /// Emitted when the SDK adds a new stream to a conference participant.
    case streamAdded = "EVENT_CONFERENCE_STREAM_ADDED"
    /// Emitted when a conference participant who is connected to the audio and video stream changes
    /// the stream by enabling a microphone while using a camera or by enabling a camera while using
    /// a microphone.
    case streamUpdated = "EVENT_CONFERENCE_STREAM_UPDATED"
    /// Emitted when the SDK removes a stream from a conference participant.
    case streamRemoved = "EVENT_CONFERENCE_STREAM_REMOVED"
}

class ConferenceServiceBinding: Binding {
    
    var current: VTConference? {
        VoxeetSDK.shared.conference.current
    }
    
    override func onInit() {
        super.onInit()
        VoxeetSDK.shared.conference.delegate = self
    }
    
    func currentConference(completionHandler: FlutterMethodCallCompletionHandler) {
        guard let conference = VoxeetSDK.shared.conference.current else {
            completionHandler.success()
            return
        }
        completionHandler.success(encodable: DTO.Confrence(conference: conference))
    }
    
    // MARK: - Methods
    /// Creates a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func create(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let options = try flutterArguments.asSingle().decode(type: DTO.ConferenceOptions.self)
            VoxeetSDK.shared.conference.create(options: options.toSdkType()) { conference in
                completionHandler.success(encodable: DTO.Confrence(conference: conference))
            } fail: { error in
                completionHandler.failure(error)
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Provides the conference object that allows joining a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func fetch(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let conferenceId: String? = try flutterArguments.asDictionary(argKey: "conferenceId").decode()
            guard let conferenceId = conferenceId else {
                currentConference(completionHandler:completionHandler)
                return
            }
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                completionHandler.success(encodable: DTO.Confrence(conference: conference))
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Joins a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func join(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        
        do {
            
            let options = try flutterArguments.asDictionary(argKey: "options")
                .decode(type: DTO.JoinOptions.self)
            let conference = try flutterArguments.asDictionary(argKey: "conference")
                .decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                throw BindingError.noConferenceId
            }
            
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                VoxeetSDK.shared.conference.join(
                    conference: conference,
                    options: options.toSdkType()) { conference in
                        completionHandler.success(encodable: DTO.Confrence(conference: conference))
                    } fail: { error in
                        completionHandler.failure(error)
                    }
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Kicks the participant from a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func kick(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.conference.kick(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Leaves the current conference.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func leave(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.conference.leave { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
    
    /// Gets the participant's audio level. The audio level value ranges from 0.0 to 1.0.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getAudioLevel(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            completionHandler.success(
                flutterConvertible: VoxeetSDK.shared.conference.audioLevel(participant: participantObject)
            )
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Provides the maximum number of video streams that may be transmitted to the local participant.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getMaxVideoForwarding(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        completionHandler.success(flutterConvertible: VoxeetSDK.shared.conference.maxVideoForwarding)
    }
    
    
    /// Starts audio transmission between the local client and a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func startAudio(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.conference.startAudio(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Stops audio transmission between the local client and a conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func stopAudio(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.conference.stopAudio(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Notifies the server to either start sending the local participant's video stream to the conference or start sending a remote participant's video stream to the local participant.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func startVideo(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.conference.startVideo(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Notifies the server to either stop sending the local participant's video stream to the conference or stop sending a remote participant's video stream to the local participant.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func stopVideo(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            VoxeetSDK.shared.conference.stopVideo(participant: participantObject) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Provides the participant with participant's id from the current conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getParticipant(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participantId: String = try flutterArguments.asDictionary(argKey: "participantId").decode()
            guard let participantObject = current?.findParticipant(with: participantId) else {
                throw BindingError.noParticipantId(participantId)
            }
            completionHandler.success(encodable: DTO.Participant(participant: participantObject))
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Provides the list of participants from the conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getParticipants(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let conference = try flutterArguments.asSingle().decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                throw BindingError.noConferenceId
            }
            if let current = current, current.id == conferenceId {
                let participants = current.participants.map { DTO.Participant(participant: $0) }
                completionHandler.success(encodable: participants)
                return
            }
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                let participants = conference.participants.map { DTO.Participant(participant: $0) }
                completionHandler.success(encodable: participants)
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Mutes or unmutes the specified user.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    func mute(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler)
    {
        do {
            let participant = try flutterArguments.asDictionary(argKey: "participant").decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            let isMuted: Bool = try flutterArguments.asDictionary(argKey: "isMuted").decode() ?? false
            VoxeetSDK.shared.conference.mute(participant: participantObject, isMuted: isMuted) { error in
                completionHandler.handleError(error)?.orSuccess({true})
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Provides the status of the conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getStatus(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        
        do {
            let conference = try flutterArguments.asSingle().decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                throw BindingError.noConferenceId
            }
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                let status = DTO.ConferenceStatus(status: conference.status)
                completionHandler.success(encodable: status)
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    
    /// Informs whether a participant is muted.
    /// - Parameters:
    /// - completionHandler: Call methods on this instance when execution has finished.
    func isMuted(
        completionHandler: FlutterMethodCallCompletionHandler)
    {
        completionHandler.success(flutterConvertible: VoxeetSDK.shared.conference.isMuted())
    }
    
    /// Gets the participant's current speaking status.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    func isSpeaking(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asSingle().decode(type: DTO.Participant.self)
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipant(String(reflecting: participant))
            }
            completionHandler.success(flutterConvertible: VoxeetSDK.shared.conference.isSpeaking(participant: participantObject))
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Enables and disables audio processing for the conference participant..
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    func setAudioProcessing(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let audioProcessing = try flutterArguments.asSingle().decode(type: DTO.AudioProcessingOptions.self)
            VoxeetSDK.shared.conference.audioProcessing(enable: audioProcessing.send?.audioProcessing ?? false)
            completionHandler.success()
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Replays the conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func replay(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let conference = try flutterArguments.asDictionary(argKey: "conference").decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                throw BindingError.noConferenceId
            }
            
            let replayOptions = VTReplayOptions()
            let offset: Int? = try flutterArguments.asDictionary(argKey: "offset").decode()
            if let offset = offset {
                replayOptions.offset = offset
            }
            replayOptions.conferenceAccessToken = try flutterArguments.asDictionary(argKey: "conferenceAccessToken").decode()
            
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                VoxeetSDK.shared.conference.replay(
                    conference: conference,
                    options: replayOptions) { error in
                        if let error = error {
                            completionHandler.failure(error)
                            return
                        }
                        guard let conference = VoxeetSDK.shared.conference.current else {
                            completionHandler.failure(BindingError.noCurrentConference)
                            return
                        }
                        completionHandler.success(encodable: DTO.Confrence(conference: conference))
                    }
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    // MARK: - User Actions
    
    /// Updates the participant's conference permissions.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func updatePermissions(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let permissions = try flutterArguments.asSingle().decode(type: [DTO.ParticipantPermissions].self)
            VoxeetSDK.shared.conference.updatePermissions(
                participantPermissions: (try permissions.map { try $0.toSdkType() })
            ) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
        
    /// Provides standard WebRTC statistics for the application.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getLocalStats(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let nativeLocalStats = VoxeetSDK.shared.conference.localStats()
            completionHandler.success(flutterConvertible: try DTO.LocalStatsFlutterConvertible(nativeLocalStats: nativeLocalStats))
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Sets the maximum number of video streams that may be transmitted to the local participant.
    /// - Parameters:
    /// - flutterArguments: Method arguments passed from Flutter.
    /// - completionHandler: Call methods on this instance when execution has finished.
    func setVideoForwarding(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let strategy = try flutterArguments.asDictionary(argKey: "strategy")
                .decode(type: DTO.VideoForwardingStrategyDTO.self)
            let max: Int = try flutterArguments.asDictionary(argKey: "max").decode()
            let participants = try flutterArguments.asDictionary(argKey: "prioritizedParticipants")
                .decode(type: [DTO.Participant].self)
            
            VoxeetSDK.shared.conference.videoForwarding(
                options: VideoForwardingOptions(
                    strategy: strategy.toSdkType(),
                    max: max,
                    participants: participants.compactMap {
                        current?.findParticipant(with: $0.id)
                    }
                )
            ) { error in
                completionHandler.handleError(error)?.orSuccess({ true })
            }
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Mutes or unmutes output (only compatible with Dolby Voice conferences).
    /// - Parameters:
    ///   - isMuted: <code>true</code> if user mutes output. Otherwise, <code>false</code>.
    ///   - resolve: returns on success
    ///   - reject: returns error on failure
    func muteOutput(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let isMuted: Bool = try flutterArguments.asDictionary(argKey: "isMuted").decode() ?? false
            VoxeetSDK.shared.conference.muteOutput(isMuted) { error in
                completionHandler.handleError(error)?.orSuccess({true})
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Starts a screen-sharing session.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func startScreenShare(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.conference.startScreenShare(broadcast: true) { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
    
    /// Stops a screen-sharing session.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func stopScreenShare(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.conference.stopScreenShare() { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
    
    /// Sets the direction a participant is facing in space.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func setSpatialDirection(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let direction = try flutterArguments.asSingle().decode(type: DTO.SpatialDirection.self)
            
            guard let participantObject = VoxeetSDK.shared.session.participant else {
                throw BindingError.noCurrentParticipant
            }
            
            VoxeetSDK.shared.conference.setSpatialDirection(participant: participantObject,
                                                            direction: direction.toSdkType()) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Configures a spatial environment of an application, so the audio renderer understands which directions the application considers forward, up, and right and which units it uses for distance.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func setSpatialEnvironment(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let scale = try flutterArguments.asDictionary(argKey: "scale").decode(type: DTO.SpatialScale.self)
            let forward = try flutterArguments.asDictionary(argKey: "forward").decode(type: DTO.SpatialPosition.self)
            let up = try flutterArguments.asDictionary(argKey: "up").decode(type: DTO.SpatialPosition.self)
            let right = try flutterArguments.asDictionary(argKey: "right").decode(type: DTO.SpatialPosition.self)

            VoxeetSDK.shared.conference.setSpatialEnvironment(scale: scale.toSdkType(),
                                                              forward: forward.toSdkType(),
                                                              up: up.toSdkType(),
                                                              right: right.toSdkType()) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Sets a participant's position in space to enable the spatial audio experience during a Dolby Voice conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func setSpatialPosition(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let participant = try flutterArguments.asDictionary(argKey: "participant").decode(type: DTO.Participant.self)
            let position = try flutterArguments.asDictionary(argKey: "position").decode(type: DTO.SpatialPosition.self)
            
            guard let participantObject = current?.findParticipant(with: participant.id) else {
                throw BindingError.noParticipantId(participant.id ?? "")
            }
            
            VoxeetSDK.shared.conference.setSpatialPosition(participant: participantObject,
                                                           position: position.toSdkType()) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Joins a conference as a listener.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func listen(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        
        do {
            let options = try flutterArguments.asDictionary(argKey: "options")
                .decode(type: DTO.ListenOptions.self)
            let conference = try flutterArguments.asDictionary(argKey: "conference")
                .decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                throw BindingError.noConferenceId
            }
            
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                VoxeetSDK.shared.conference.listen(conference: conference, options: options.toSdkType()) { conference in
                    completionHandler.success(encodable: DTO.Confrence(conference: conference))
                } fail: { error in
                    completionHandler.failure(error)
                }
            }
        } catch {
            
        }
    }
}

extension ConferenceServiceBinding: VTConferenceDelegate {
    func statusUpdated(status: VTConferenceStatus) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.statusUpdated,
                body: DTO.ConferenceStatus(status: status)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func permissionsUpdated(permissions: [Int]) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.permissionsUpdated,
                body: permissions.map { (rawPermission: Int) -> DTO.ConferencePermission in
                    guard let vtConferencePermission = VTConferencePermission(rawValue: rawPermission) else {
                        throw EncoderError.createObjectFailed()
                    }
                    return DTO.ConferencePermission(conferencePermision: vtConferencePermission)
                }
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func participantAdded(participant: VTParticipant) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.participantAdded,
                body: DTO.Participant(participant: participant)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func participantUpdated(participant: VTParticipant) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.participantUpdated,
                body: DTO.Participant(participant: participant)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func streamAdded(participant: VTParticipant, stream: MediaStream) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.streamAdded,
                body: StreamsChangeData(
                    participant: participant,
                    stream: stream
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func streamUpdated(participant: VTParticipant, stream: MediaStream) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.streamUpdated,
                body: StreamsChangeData(
                    participant: participant,
                    stream: stream
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func streamRemoved(participant: VTParticipant, stream: MediaStream) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.streamRemoved,
                body: StreamsChangeData(
                    participant: participant,
                    stream: stream
                )
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension ConferenceServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "current":
            currentConference(completionHandler: completionHandler)
        case "create":
            create(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "fetch":
            fetch(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "join":
            join(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "kick":
            kick(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "leave":
            leave(completionHandler: completionHandler)
        case "replay":
            replay(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getAudioLevel":
            getAudioLevel(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getMaxVideoForwarding":
            getMaxVideoForwarding(completionHandler: completionHandler)
        case "startAudio":
            startAudio(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "stopAudio":
            stopAudio(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "startVideo":
            startVideo(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "stopVideo":
            stopVideo(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "startScreenShare":
            startScreenShare(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "stopScreenShare":
            stopScreenShare(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getParticipant":
            getParticipant(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getParticipants":
            getParticipants(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "setSpatialDirection":
            setSpatialDirection(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "setSpatialPosition":
            setSpatialPosition(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "setSpatialEnvironment":
            setSpatialEnvironment(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "mute":
            mute(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getStatus":
            getStatus(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "isMuted":
            isMuted(completionHandler: completionHandler)
        case "isSpeaking":
            isSpeaking(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getLocalStats":
            getLocalStats(completionHandler: completionHandler)
        case "setVideoForwarding":
            setVideoForwarding(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "setAudioProcessing":
            setAudioProcessing(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "muteOutput":
            muteOutput(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "updatePermissions":
            updatePermissions(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "listen":
            listen(flutterArguments: flutterArguments, completionHandler: completionHandler)
            
        default:
            completionHandler.methodNotImplemented()
        }
        
    }
    
    
}

extension VTConference {
    func findParticipant(with identifier: String?) -> VTParticipant? {
        guard let identifier = identifier else { return nil }
        return participants.first(where: { $0.id == identifier })
    }
}

private struct StreamsChangeData: Encodable {
    let participant: DTO.Participant
    let stream: DTO.MediaStream
    init(participant: VTParticipant, stream: MediaStream) {
        self.participant = DTO.Participant(participant: participant)
        self.stream = DTO.MediaStream(mediaStream: stream)
    }
}
