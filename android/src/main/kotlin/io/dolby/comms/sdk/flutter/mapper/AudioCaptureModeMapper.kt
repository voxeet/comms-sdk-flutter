package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.capture.audio.AudioCaptureMode
import com.voxeet.android.media.capture.audio.Mode
import com.voxeet.android.media.capture.audio.noise.NoiseReduction
import com.voxeet.android.media.capture.audio.noise.StandardNoiseReduction

class AudioCaptureModeMapper(private val audioCaptureMode: AudioCaptureMode) : Mapper() {

    override fun convertToMap() = mapOf(
        "mode" to audioCaptureMode.mode.convertToString(),
        "noiseReduction" to audioCaptureMode.noiseReduction?.convertToString(),
    )

    private fun Mode.convertToString(): String = when (this) {
        Mode.STANDARD -> "STANDARD"
        Mode.UNPROCESSED -> "UNPROCESSED"
    }

    private fun NoiseReduction.convertToString(): String = when (this) {
        NoiseReduction.HIGH -> "HIGH"
        else -> "LOW"
    }

    companion object {
        fun fromMap(map: Map<String, Any?>): AudioCaptureMode {
            return when (toMode(map["mode"] as String?)) {
                Mode.STANDARD -> AudioCaptureMode.standard(toNoiseReduction(map["noiseReduction"] as String?))
                Mode.UNPROCESSED -> AudioCaptureMode.unprocessed()
            }
        }

        private fun toMode(mode: String?): Mode = when (mode) {
            "UNPROCESSED" -> Mode.UNPROCESSED
            else -> Mode.STANDARD
        }

        private fun toNoiseReduction(noiseReduction: String?) = when (noiseReduction) {
            "HIGH" -> StandardNoiseReduction.HIGH
            else -> StandardNoiseReduction.LOW
        }
    }
}


