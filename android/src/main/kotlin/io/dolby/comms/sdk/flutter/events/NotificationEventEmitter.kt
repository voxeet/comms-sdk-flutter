package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.push.center.subscription.event.InvitationReceivedNotificationEvent
import com.voxeet.sdk.push.center.subscription.event.ConferenceCreatedNotificationEvent
import com.voxeet.sdk.push.center.subscription.event.ConferenceEndedNotificationEvent
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
     * Emitted when conference was created.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: ConferenceCreatedNotificationEvent) {
        mapOf(
            KEY_CONFERENCE_ALIAS to event.conferenceAlias,
            KEY_CONFERENCE_ID to event.conferenceId
        ).also { emit(NotificationEvent.CONFERENCE_CREATED, it) }
    }

    /**
     * Emitted when conference was ended.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: ConferenceEndedNotificationEvent) {
        mapOf(
            KEY_CONFERENCE_ALIAS to event.conferenceAlias,
            KEY_CONFERENCE_ID to event.conferenceId
        ).also { emit(NotificationEvent.CONFERENCE_ENDED, it) }
    }

    /**
     * Notification events
     */
    private object NotificationEvent {
        const val INVITATION_RECEIVED = "EVENT_NOTIFICATION_INVITATION_RECEIVED"
        const val CONFERENCE_CREATED = "EVENT_NOTIFICATION_CONFERENCE_CREATED"
        const val CONFERENCE_ENDED = "EVENT_NOTIFICATION_CONFERENCE_ENDED"
    }

    companion object {
        private const val KEY_CONFERENCE_ALIAS = "conferenceAlias"
        private const val KEY_CONFERENCE_ID = "conferenceId"
    }
}
