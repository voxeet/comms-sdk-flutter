package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.utils.ComfortNoiseLevel

class ComfortNoiseLevelMapper {
    companion object {
        fun convertFromString(comfortNoiseLevel: String?) = when (comfortNoiseLevel) {
            "default" -> ComfortNoiseLevel.DEFAULT
            "medium" -> ComfortNoiseLevel.MEDIUM
            "low" -> ComfortNoiseLevel.LOW
            "off" -> ComfortNoiseLevel.OFF
            else -> null
        }

        fun convertToString(comfortNoiseLevel: ComfortNoiseLevel) = when (comfortNoiseLevel) {
            ComfortNoiseLevel.DEFAULT -> "default"
            ComfortNoiseLevel.MEDIUM -> "medium"
            ComfortNoiseLevel.LOW -> "low"
            ComfortNoiseLevel.OFF -> "off"
        }
    }
}
