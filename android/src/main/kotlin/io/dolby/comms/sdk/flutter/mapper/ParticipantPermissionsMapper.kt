package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.json.ConferencePermission
import com.voxeet.sdk.models.ParticipantPermissions

class ParticipantPermissionsMapper(private val participantPermissions: ParticipantPermissions) : Mapper() {

    override fun convertToMap(): Map<String, Any?> = mapOf(
        "participant" to ParticipantMapper(participantPermissions.participant).convertToMap(),
        "permissions" to participantPermissions.permissions.map { it.name }
    )

    companion object {
        fun fromMap(map: Map<String, Any?>) = ParticipantPermissions().apply {
            (map["participant"] as? Map<String, Any?>)
                ?.let { ParticipantMapper.fromMap(it) }
                ?.let { this.participant = it }
            (map["permissions"] as? List<String>)
                ?.map { value -> ConferencePermission.valueOf(value) }
                ?.toSet()
                ?.let { this.permissions = it }
        }
    }
}
