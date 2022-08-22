package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.MediaEngine

class ComfortNoiseLevelMapper {
    companion object {
        fun convertFromString(comfortNoiseLevel: String?) = when (comfortNoiseLevel) {
            "default" -> MediaEngine.ComfortNoiseLevel.DEFAULT
            "medium" -> MediaEngine.ComfortNoiseLevel.MEDIUM
            "low" -> MediaEngine.ComfortNoiseLevel.LOW
            "off" -> MediaEngine.ComfortNoiseLevel.OFF
            else -> null
        }

        fun convertToString(comfortNoiseLevel: MediaEngine.ComfortNoiseLevel) = when (comfortNoiseLevel) {
            MediaEngine.ComfortNoiseLevel.DEFAULT -> "default"
            MediaEngine.ComfortNoiseLevel.MEDIUM -> "medium"
            MediaEngine.ComfortNoiseLevel.LOW -> "low"
            MediaEngine.ComfortNoiseLevel.OFF -> "off"
        }
    }
}