package io.dolby.comms.sdk.flutter.events
import com.voxeet.VoxeetSDK
import com.voxeet.sdk.push.center.subscription.event.ActiveParticipantsEvent
import com.voxeet.sdk.push.center.subscription.event.InvitationReceivedNotificationEvent
import com.voxeet.sdk.push.center.subscription.event.ConferenceCreatedNotificationEvent
import com.voxeet.sdk.push.center.subscription.event.ConferenceEndedNotificationEvent
import com.voxeet.sdk.push.center.subscription.event.ParticipantJoinedNotificationEvent
import com.voxeet.sdk.push.center.subscription.event.ParticipantLeftNotificationEvent
import com.voxeet.sdk.services.notification.events.ConferenceStatusNotificationEvent
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
     * Emitted when a list of active participants changes..
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: ActiveParticipantsEvent) {
        mapOf(
            KEY_CONFERENCE_ALIAS to event.conferenceAlias,
            KEY_CONFERENCE_ID to event.conferenceId,
            KEY_PARTICIPANT_COUNT to event.participantCount,
            KEY_PARTICIPANTS to event.participants.map {
                ParticipantNotificationMapper(it).convertToMap()
            }
        ).also { emit(NotificationEvent.ACTIVE_PARTICIPANTS, it) }
    }

    /**
     * Emitted when participant joined the conference.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: ParticipantJoinedNotificationEvent) {
        mapOf(
            KEY_CONFERENCE_ALIAS to event.conferenceAlias,
            KEY_CONFERENCE_ID to event.conferenceId,
            KEY_PARTICIPANT to ParticipantNotificationMapper(event.participant).convertToMap()
        ).also { emit(NotificationEvent.PARTICIPANT_JOINED, it) }
    }

    /**
     * Emitted when participant left the conference.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: ParticipantLeftNotificationEvent) {
        mapOf(
            KEY_CONFERENCE_ALIAS to event.conferenceAlias,
            KEY_CONFERENCE_ID to event.conferenceId,
            KEY_PARTICIPANT to ParticipantNotificationMapper(event.participant).convertToMap()
        ).also { emit(NotificationEvent.PARTICIPANT_LEFT, it) }
    }

    /**
     * Emitted when conference status is updated.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: ConferenceStatusNotificationEvent) {
        mapOf(
            KEY_CONFERENCE_ID to event.conferenceId,
            KEY_CONFERENCE_ALIAS to event.conferenceAlias,
            KEY_IS_LIVE to event.isLive,
            KEY_PARTICIPANTS to event.participants.map {
                ParticipantNotificationMapper(it).convertToMap()
            }
        ).also { emit(NotificationEvent.CONFERENCE_STATUS, it) }
    }

    /**
     * Notification events
     */
    private object NotificationEvent {
        const val INVITATION_RECEIVED = "EVENT_NOTIFICATION_INVITATION_RECEIVED"
        const val CONFERENCE_CREATED = "EVENT_NOTIFICATION_CONFERENCE_CREATED"
        const val CONFERENCE_ENDED = "EVENT_NOTIFICATION_CONFERENCE_ENDED"
        const val PARTICIPANT_JOINED = "EVENT_NOTIFICATION_PARTICIPANT_JOINED"
        const val PARTICIPANT_LEFT = "EVENT_NOTIFICATION_PARTICIPANT_LEFT"
        const val ACTIVE_PARTICIPANTS = "EVENT_NOTIFICATION_ACTIVE_PARTICIPANTS"
        const val CONFERENCE_STATUS = "EVENT_NOTIFICATION_CONFERENCE_STATUS"
    }

    companion object {
        private const val KEY_CONFERENCE_ALIAS = "conferenceAlias"
        private const val KEY_CONFERENCE_ID = "conferenceId"
        private const val KEY_PARTICIPANT_COUNT = "participantCount"
        private const val KEY_PARTICIPANTS = "participants"
        private const val KEY_PARTICIPANT = "participant"
        private const val KEY_IS_LIVE = "live"
    }
}
