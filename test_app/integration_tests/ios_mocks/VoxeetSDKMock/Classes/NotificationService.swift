import Foundation
import WebRTC

@objcMembers public class NotificationService: NSObject {

    public weak var delegate: VTNotificationDelegate?

    var subscribeHasRun: Bool = false
    var subscribArgs: [VTSubscribeBase]?
    public func subscribe(subscriptions:[VTSubscribeBase]) {
        subscribeHasRun = true
        subscribArgs = subscriptions
    }

    var unsubscribeHasRun: Bool = false
    var unsubscribArgs: [VTSubscribeBase]?
    public func unsubscribe(subscriptions:[VTSubscribeBase]) {
        unsubscribeHasRun = true
        unsubscribArgs = subscriptions
    }

    var inviteHasRun: Bool = false
    var inviteArgs: (conference: VTConference, participantsInvited: [VTParticipantInvited])?
    var inviteReturn: NSError?
    public func invite(conference: VTConference, participantsInvited: [VTParticipantInvited], completion: ((_ error: NSError?) -> Void)? = nil) {
        inviteHasRun = true
        inviteArgs = (conference, participantsInvited)
        completion?(inviteReturn)
    }

    var declineHasRun: Bool = false
    var declineArgs: VTConference?
    var declineReturn: NSError?
    public func decline(conference: VTConference, completion: ((_ error: NSError?) -> Void)? = nil) {
        declineHasRun = true
        declineArgs = conference
        completion?(declineReturn)
    }
}

@objc public protocol VTNotificationDelegate {
    /// Emitted when an invitation has been received.
    @objc func invitationReceived(notification: VTInvitationReceivedNotification)
    /// Emitted when a conference has been subscribed.
    @objc func conferenceStatus(notification: VTConferenceStatusNotification)
    /// Emitted when a conference has been created.
    @objc func conferenceCreated(notification: VTConferenceCreatedNotification)
    /// Emitted when a conference has been ended.
    @objc func conferenceEnded(notification: VTConferenceEndedNotification)
    /// Emitted when a participant joined a conference.
    @objc func participantJoined(notification: VTParticipantJoinedNotification)
    /// Emitted when a participant left a conference.
    @objc func participantLeft(notification: VTParticipantLeftNotification)
    /// Emitted when active participants changed.
    @objc func activeParticipants(notification: VTActiveParticipantsNotification)
}
