package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.Participant

class VideoPresentationMapper(private val owner: Participant, private val url: String, private val timestamp: Long) : Mapper() {
    override fun convertToMap() = mapOf(
        "owner" to (of(owner)?.convertToMap() ?: emptyMap()),
        "url" to url,
        "timestamp" to timestamp
    )
}
