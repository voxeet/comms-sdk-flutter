package io.dolby.comms.sdk.flutter.mapper

import android.content.res.Resources
import com.voxeet.sdk.push.center.subscription.register.*

object SubscriptionMapper {
    @JvmStatic
    fun fromMap(map: Map<String, Any?>): BaseSubscription? {
        val conferenceAlias = map["conferenceAlias"] as? String
            ?: throw Resources.NotFoundException("conferenceAlias not found")
        return when (map["type"]) {
            SUBSCRIPTION_TYPE_CONFERENCE_CREATED -> SubscribeConferenceCreated(conferenceAlias)
            SUBSCRIPTION_TYPE_CONFERENCE_ENDED -> SubscribeConferenceEnded(conferenceAlias)
            SUBSCRIPTION_TYPE_ACTIVE_PARTICIPANTS -> SubscribeActiveParticipants(conferenceAlias)
            SUBSCRIPTION_TYPE_PARTICIPANT_JOINED -> SubscribeParticipantJoined(conferenceAlias)
            SUBSCRIPTION_TYPE_PARTICIPANT_LEFT -> SubscribeParticipantLeft(conferenceAlias)
            SUBSCRIPTION_TYPE_INVITATION_RECEIVED -> SubscribeInvitation()
            else -> throw java.lang.Exception("Incorrect type of subscription")
        }
    }

    private const val SUBSCRIPTION_TYPE_CONFERENCE_CREATED = "SUBSCRIPTION_TYPE_CONFERENCE_CREATED"
    private const val SUBSCRIPTION_TYPE_CONFERENCE_ENDED = "SUBSCRIPTION_TYPE_CONFERENCE_ENDED"
    private const val SUBSCRIPTION_TYPE_ACTIVE_PARTICIPANTS =
        "SUBSCRIPTION_TYPE_ACTIVE_PARTICIPANTS"
    private const val SUBSCRIPTION_TYPE_PARTICIPANT_JOINED = "SUBSCRIPTION_TYPE_PARTICIPANT_JOINED"
    private const val SUBSCRIPTION_TYPE_PARTICIPANT_LEFT = "SUBSCRIPTION_TYPE_PARTICIPANT_LEFT"
    private const val SUBSCRIPTION_TYPE_INVITATION_RECEIVED =
        "SUBSCRIPTION_TYPE_INVITATION_RECEIVED"
}