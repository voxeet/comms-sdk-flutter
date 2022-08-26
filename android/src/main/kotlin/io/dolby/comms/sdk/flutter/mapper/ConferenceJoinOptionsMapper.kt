package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.media.constraints.Constraints
import com.voxeet.sdk.services.builders.ConferenceJoinOptions
import com.voxeet.sdk.services.conference.information.ConferenceParticipantType

class ConferenceJoinOptionsMapper {

    companion object {
        fun fromMap(map: Map<String, Any?>?): ConferenceJoinOptions? {
            if (map == null)
                return null
            val conference = map["conference"] as? Map<String, Any?>
            val options = map["options"] as? Map<String, Any?>
            val conferenceId = conference?.get("id") as? String
            return conferenceId?.let { confId ->
                val constraints = options?.let { opt ->
                    ConstraintsMapper.toObject(opt["constraints"] as? Map<String, Any?>)
                } ?: Constraints(false, false)
                val builder = ConferenceJoinOptions
                    .Builder(VoxeetSDK.conference().getConference(confId))
                (options?.get("conferenceAccessToken") as? String)?.let { token ->
                    builder.setConferenceAccessToken(token)
                }
                (options?.get("maxVideoForwarding") as? Int)?.let { maxForwarding ->
                    builder.setMaxVideoForwarding(maxForwarding)
                }
                builder
                    .setConstraints(constraints)
                    .setConferenceParticipantType(ConferenceParticipantType.NORMAL)
                    .setSpatialAudio(options?.get("spatialAudio") as? Boolean ?: false)
                    .build()
            }
        }
    }
}
