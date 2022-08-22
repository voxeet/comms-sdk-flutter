package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.spatialisation.SpatialDirection

class SpatialDirectionMapper {
    companion object {
        fun fromMap(map: Map<String, Any?>?): SpatialDirection? {
            if (map == null || !map.contains("x") || !map.contains("y") || !map.contains("z"))
                return null
            return SpatialDirection(map["x"] as Double, map["y"] as Double, map["z"] as Double)
        }
    }
}
