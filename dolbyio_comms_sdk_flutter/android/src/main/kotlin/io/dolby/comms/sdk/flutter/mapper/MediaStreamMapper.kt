package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.MediaStream
import com.voxeet.android.media.stream.MediaStreamType
import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.models.v2.ParticipantMediaStreamHandler
import com.voxeet.sdk.utils.Opt

class MediaStreamMapper(private val obj: MediaStream) : Mapper() {
    override fun convertToMap() = mapOf(
        "type" to obj.type.name,
        "label" to obj.label(),
        "id" to obj.peerId(),
        "videoTracks" to obj.videoTracks().map { it?.id() },
        "audioTracks" to obj.audioTracks().map { it?.id() }
    )

    companion object {
        fun firstForParticipant(participant: Participant): MediaStream? {
            return Opt.of(participant).then { obj: Participant -> obj.streamsHandler() }
                .then { s: ParticipantMediaStreamHandler ->
                    s.getFirst(
                        MediaStreamType.Camera
                    )
                }
                .orNull()
        }
    }
}
