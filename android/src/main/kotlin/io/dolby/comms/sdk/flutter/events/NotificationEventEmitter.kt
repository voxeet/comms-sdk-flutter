package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.push.center.subscription.event.InvitationReceivedNotificationEvent
import io.dolby.comms.sdk.flutter.mapper.ParticipantNotificationMapper
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode.MAIN

/**
 * The notification event emitter
 */
class NotificationEventEmitter(eventChannelHandler: EventChannelHandler) : NativeEventEmitter(eventChannelHandler) {

    /**
     * Emitted when the application user received an invitation.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: InvitationReceivedNotificationEvent) {
        val invitation = event.invitation
        val conference = invitation.conferenceId?.let { VoxeetSDK.conference().getConference(it) } ?: return

        mapOf(
            "conferenceAlias" to conference.alias,
            "conferenceId" to conference.id,
            "participant" to ParticipantNotificationMapper(invitation.inviter).convertToMap()
        ).let { emit(NotificationEvent.INVITATION_RECEIVED, it) }
    }

    /**
     * Notification events
     */
    private object NotificationEvent {
        const val INVITATION_RECEIVED = "EVENT_NOTIFICATION_INVITATION_RECEIVED"
    }
}
