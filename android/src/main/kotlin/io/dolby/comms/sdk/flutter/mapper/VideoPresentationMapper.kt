package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.services.presentation.PresentationState

class VideoPresentationMapper(private val owner: Participant, private val url: String, private val timestamp: Long) : Mapper() {
    override fun convertToMap() = mapOf(
        "owner" to (of(owner)?.convertToMap() ?: emptyMap()),
        "url" to url,
        "timestamp" to timestamp
    )
}

fun PresentationState.mapToFlutter() = when(this){
    PresentationState.STARTED,
    PresentationState.SEEK,
    PresentationState.PLAY -> "play"
    PresentationState.PAUSED -> "paused"
    PresentationState.CONVERTED,
    PresentationState.STOP -> "stopped"
}
