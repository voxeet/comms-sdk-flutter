package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.json.ParticipantInfo

class ParticipantInfoMapper(private val info: ParticipantInfo) : Mapper() {
    override fun convertToMap(): Map<String, Any?> = mapOf(
        "externalId" to info.externalId,
        "avatarUrl" to info.avatarUrl,
        "name" to info.name
    )

    companion object {
        fun fromMap(map: Map<String, Any?>)= ParticipantInfo(
            map["name"] as? String,
            map["externalId"] as? String,
            map["avatarUrl"] as? String
        )
    }
}
