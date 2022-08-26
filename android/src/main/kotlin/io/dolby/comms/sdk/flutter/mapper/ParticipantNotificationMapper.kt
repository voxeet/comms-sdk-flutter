package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.ParticipantNotification

class ParticipantNotificationMapper(private val participantNotification: ParticipantNotification) : Mapper() {
    override fun convertToMap() = mapOf(
        "id" to participantNotification.id,
        "status" to participantNotification.status.name,
        "info" to participantNotification.info?.let {
            mapOf(
                "name" to it.name,
                "externalId" to it.externalId,
                "avatarUrl" to it.avatarUrl
            )
        }
    )
}
