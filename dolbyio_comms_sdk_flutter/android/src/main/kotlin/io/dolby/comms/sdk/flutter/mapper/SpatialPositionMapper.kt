package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.spatialisation.SpatialPosition

class SpatialPositionMapper {
    companion object {
        fun fromMap(map: Map<String, Any?>?): SpatialPosition? {
            if (map == null || !map.contains("x") || !map.contains("y") || !map.contains("z"))
                return null
            return SpatialPosition(map["x"] as Double, map["y"] as Double, map["z"] as Double)
        }
    }
}
