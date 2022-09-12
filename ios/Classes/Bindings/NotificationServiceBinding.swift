import Foundation
import VoxeetSDK

private enum EventKeys: String, CaseIterable {
    /// Emitted when the application user received an invitation.
    case invitationReceived = "EVENT_NOTIFICATION_INVITATION_RECEIVED"
}

class NotificationServiceBinding: Binding {

    override func onInit() {
        VoxeetSDK.shared.notification.delegate = self
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
            guard let conference = try flutterArguments.asDictionary(argKey: "conference").decode(type: DTO.Confrence.self),
                  let conferenceId = conference.id else {
                      throw BindingError.noConferenceId
                  }
            let participantInvited = try flutterArguments.asDictionary(argKey: "participants").decode(type: [DTO.ParticipantInvited].self)
            VoxeetSDK.shared.conference.fetch(conferenceID: conferenceId) { conference in
                VoxeetSDK.shared.notification.invite(
                    conference: conference,
                    participantsInvited: participantInvited?.map { $0.toSdkType() } ?? []
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
            guard let conference = try flutterArguments.asDictionary(argKey: "conference").decode(type: DTO.Confrence.self),
                  let conferenceId = conference.id else {
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
    public func conferenceStatus(notification: VTConferenceStatusNotification) {}
    public func conferenceCreated(notification: VTConferenceCreatedNotification) {}
    public func conferenceEnded(notification: VTConferenceEndedNotification) {}
    public func participantJoined(notification: VTParticipantJoinedNotification) {}
    public func participantLeft(notification: VTParticipantLeftNotification) {}
}
