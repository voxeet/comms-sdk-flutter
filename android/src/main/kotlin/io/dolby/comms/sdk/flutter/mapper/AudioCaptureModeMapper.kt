package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.capture.audio.AudioCaptureMode
import com.voxeet.android.media.capture.audio.Mode
import com.voxeet.android.media.capture.audio.VoiceFont
import com.voxeet.android.media.capture.audio.noise.NoiseReduction
import com.voxeet.android.media.capture.audio.noise.StandardNoiseReduction

class AudioCaptureModeMapper(private val audioCaptureMode: AudioCaptureMode) : Mapper() {

    override fun convertToMap() = mapOf(
        "mode" to audioCaptureMode.mode.convertToString(),
        "noiseReduction" to audioCaptureMode.noiseReduction?.convertToString(),
        "voiceFont" to audioCaptureMode.voiceFont?.convertToString(),
    )

    private fun Mode.convertToString(): String = when (this) {
        Mode.STANDARD -> "standard"
        Mode.UNPROCESSED -> "unprocessed"
    }

    private fun NoiseReduction.convertToString(): String = when (this) {
        NoiseReduction.HIGH -> "high"
        else -> "low"
    }

    private fun VoiceFont.convertToString(): String = when (this) {
        VoiceFont.MASCULINE -> "masculine"
        VoiceFont.FEMININE -> "feminine"
        VoiceFont.HELIUM -> "helium"
        VoiceFont.DARK_MODULATION -> "dark_modulation"
        VoiceFont.BROKEN_ROBOT -> "broken_robot"
        VoiceFont.INTERFERENCE -> "interference"
        VoiceFont.ABYSS -> "abyss"
        VoiceFont.WOBBLE -> "wobble"
        VoiceFont.STARSHIP_CAPTAIN -> "starship_captain"
        VoiceFont.NERVOUS_ROBOT -> "nervous_robot"
        VoiceFont.SWARM -> "swarm"
        VoiceFont.AM_RADIO -> "am_radio"
        else -> "none"
    }

    companion object {
        fun fromMap(map: Map<String, Any?>): AudioCaptureMode {
            val voiceFont = toVoiceFont(map["voiceFont"] as String?)
            return when (toMode(map["mode"] as String?)) {
                Mode.STANDARD -> AudioCaptureMode.standard(toNoiseReduction(map["noiseReduction"] as String?), voiceFont)
                Mode.UNPROCESSED -> AudioCaptureMode.unprocessed()
            }
        }

        private fun toMode(mode: String?): Mode = when (mode) {
            "unprocessed" -> Mode.UNPROCESSED
            else -> Mode.STANDARD
        }

        private fun toVoiceFont(font: String?): VoiceFont = when (font) {
            "masculine" -> VoiceFont.MASCULINE
            "feminine" -> VoiceFont.FEMININE
            "helium" -> VoiceFont.HELIUM
            "dark_modulation" -> VoiceFont.DARK_MODULATION
            "broken_robot" -> VoiceFont.BROKEN_ROBOT
            "interference" -> VoiceFont.INTERFERENCE
            "abyss" -> VoiceFont.ABYSS
            "wobble" -> VoiceFont.WOBBLE
            "starship_captain" -> VoiceFont.STARSHIP_CAPTAIN
            "nervous_robot" -> VoiceFont.NERVOUS_ROBOT
            "swarm" -> VoiceFont.SWARM
            "am_radio" -> VoiceFont.AM_RADIO
            else -> VoiceFont.NONE
        }

        private fun toNoiseReduction(noiseReduction: String?) = when (noiseReduction) {
            "high" -> StandardNoiseReduction.HIGH
            else -> StandardNoiseReduction.LOW
        }
    }
}


