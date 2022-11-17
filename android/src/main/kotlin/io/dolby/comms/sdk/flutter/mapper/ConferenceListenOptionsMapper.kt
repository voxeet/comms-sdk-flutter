package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.models.VideoForwardingStrategy
import com.voxeet.sdk.services.builders.ConferenceListenOptions

class ConferenceListenOptionsMapper {

    companion object {
        fun fromMap(map: Map<String, Any?>?): ConferenceListenOptions? {
            if (map == null)
                return null
            val conference = map["conference"] as? Map<String, Any?>
            val options = map["options"] as? Map<String, Any?>
            val conferenceId = conference?.get("id") as? String
            return conferenceId?.let { confId ->
                val builder = ConferenceListenOptions
                    .Builder(VoxeetSDK.conference().getConference(confId))
                (options?.get("conferenceAccessToken") as? String)?.let { token ->
                    builder.setConferenceAccessToken(token)
                }
                (options?.get("maxVideoForwarding") as? Int)?.let { maxForwarding ->
                    builder.setMaxVideoForwarding(maxForwarding)
                }
                (options?.get("videoForwardingStrategy") as? String)?.let {
                    builder.setVideoForwardingStrategy(VideoForwardingStrategy.valueOf(it))
                }
                builder
                    .setSpatialAudio(options?.get("spatialAudio") as? Boolean ?: false)
                    .build()
            }
        }
    }
}
