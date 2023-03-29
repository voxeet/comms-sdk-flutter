import Foundation
import VoxeetSDK

private enum EventKeys: String, CaseIterable {
    /// Emitted when the application user received an invitation.
    case invitationReceived = "EVENT_NOTIFICATION_INVITATION_RECEIVED"
    case conferenceStatus = "EVENT_NOTIFICATION_CONFERENCE_STATUS"
    case conferenceCraeted = "EVENT_NOTIFICATION_CONFERENCE_CREATED"
    case conferenceEnded = "EVENT_NOTIFICATION_CONFERENCE_ENDED"
    case participantJoined = "EVENT_NOTIFICATION_PARTICIPANT_JOINED"
    case participantLeft = "EVENT_NOTIFICATION_PARTICIPANT_LEFT"
}

class NotificationServiceBinding: Binding {

    override func onInit() {
        VoxeetSDK.shared.notification.delegate = self
    }

    /// Subscribes to the specified notifications.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func subscribe(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let subscriptions = try flutterArguments.asDictionary(argKey: "subscriptions").decode(type: [DTO.Subscription].self)
            VoxeetSDK.shared.notification.subscribe(subscriptions: subscriptions.map { $0.toSdkType() })
            completionHandler.success()
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Unsubscribes from the specified notifications.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func unsubscribe(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let subscriptions = try flutterArguments.asDictionary(argKey: "subscriptions").decode(type: [DTO.Subscription].self)
            VoxeetSDK.shared.notification.unsubscribe(subscriptions: subscriptions.map { $0.toSdkType() })
            completionHandler.success()
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Notifies conference participants about a conference invitation.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func invite(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let conference = try flutterArguments.asDictionary(argKey: "conference").decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                throw BindingError.noConferenceId
            }
            let participantInvited = try flutterArguments.asDictionary(argKey: "participants").decode(type: [DTO.ParticipantInvited].self)
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                VoxeetSDK.shared.notification.invite(
                    conference: conference,
                    participantsInvited: participantInvited.map { $0.toSdkType() }
                ) { error in
                    completionHandler.handleError(error)?.orSuccess()
                }
            }
        } catch {
            completionHandler.failure(error)
        }
    }

    /// Declines an invitation to a specific conference.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func decline(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let conference = try flutterArguments.asDictionary(argKey: "conference").decode(type: DTO.Confrence.self)
            guard let conferenceId = conference.id else {
                      throw BindingError.noConferenceId
                  }
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                VoxeetSDK.shared.notification.decline(conference: conference) { error in
                    completionHandler.handleError(error)?.orSuccess()
                }
            }
        } catch {
            completionHandler.failure(error)
        }
    }
}

extension NotificationServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "subscribe":
            subscribe(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "unsubscribe":
            unsubscribe(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "invite":
            invite(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "decline":
            decline(flutterArguments: flutterArguments, completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}

extension NotificationServiceBinding: VTNotificationDelegate {

    public func invitationReceived(notification: VTInvitationReceivedNotification) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.invitationReceived,
                body: DTO.InvitationReceivedNotification(invitationReceivedNotification: notification)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func activeParticipants(notification: VTActiveParticipantsNotification) {}
    public func conferenceStatus(notification: VTConferenceStatusNotification) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.conferenceStatus,
                body: DTO.ConferenceStatusNotification(conferenceStatusNotification: notification)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func conferenceCreated(notification: VTConferenceCreatedNotification) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.conferenceCraeted,
                body: DTO.ConferenceCreated(conferenceCreatedNotification: notification)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func conferenceEnded(notification: VTConferenceEndedNotification) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.conferenceEnded,
                body: DTO.ConferenceEnded(conferenceEndedNotification: notification)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func participantJoined(notification: VTParticipantJoinedNotification) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.participantJoined,
                body: DTO.ParticipantJoinedNotification(participantJoinedNotification: notification)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func participantLeft(notification: VTParticipantLeftNotification) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.participantLeft,
                body: DTO.ParticipantLeftNotification(participantLeftNotification: notification)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
