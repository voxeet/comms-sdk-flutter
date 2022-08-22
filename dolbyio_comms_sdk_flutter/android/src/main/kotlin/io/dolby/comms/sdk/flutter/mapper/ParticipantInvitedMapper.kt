package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.json.ConferencePermission
import com.voxeet.sdk.json.ParticipantInvited

class ParticipantInvitedMapper {
    companion object {
        fun fromMap(map: Map<String, Any?>): ParticipantInvited = map.let {
            val info = ParticipantInfoMapper.fromMap(it["info"] as Map<String, Any?>)
            val result = ParticipantInvited(info)
            result.permissions = (it["permissions"] as? List<String>)?.map { value ->
                ConferencePermission.valueOf(value)
            }?.toSet()
            return result
        }
    }
}
