package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.Conference
import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.services.conference.spatialisation.SpatialAudioStyle

class ConferenceMapper(private val conference: Conference) : Mapper() {

    override fun convertToMap() = mapOf(
        "id" to conference.id,
        "alias" to conference.alias,
        "isNew" to conference.isNew,
        "participants" to convertParticipants(conference.participants),
        "status" to conference.state.name,
        "spatialAudioStyle" to conference.spatialAudioStyle?.name
    )

    private fun convertParticipants(participants: List<Participant>) = participants.map {
        of(it)?.convertToMap() ?: emptyMap()
    }
}
