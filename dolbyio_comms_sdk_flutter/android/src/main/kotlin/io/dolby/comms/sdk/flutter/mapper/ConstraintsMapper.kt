package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.media.constraints.Constraints

class ConstraintsMapper {

    companion object {
        fun toObject(map: Map<String, Any?>?): Constraints {
            /*TODO Refactor this part of code. Three different case return the same value = null:
               * if map is null
               * if audio/video key doesn't exist
               * if value for audio/video key is not Boolean type
               Right now this code is very hard to debug
             */
            val audio = map?.get("audio") as? Boolean
            val video = map?.get("video") as? Boolean
            return Constraints(audio ?: false, video ?: false)
        }
    }
}
