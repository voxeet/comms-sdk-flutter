package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.json.ParticipantInfo
import com.voxeet.sdk.models.Participant

class ParticipantMapper(private val participant: Participant) : Mapper() {
    override fun convertToMap() = mapOf(
        "id" to participant.id,
        "info" to convertParticipantInfo(participant.info),
        "type" to participant.participantType().name,
        "status" to participant.status.name,
        "streams" to participant.streams().map { of(it)?.convertToMap()}
    )

    private fun convertParticipantInfo(info: ParticipantInfo?) = info?.let { of(info)?.convertToMap() ?: emptyMap() }

    companion object {
        fun fromMap(map: Map<String, Any?>?): Participant? {
            if (map == null || !map.contains("id"))
                return null
            return VoxeetSDK.conference().findParticipantById(map["id"] as String)
        }
    }
}
