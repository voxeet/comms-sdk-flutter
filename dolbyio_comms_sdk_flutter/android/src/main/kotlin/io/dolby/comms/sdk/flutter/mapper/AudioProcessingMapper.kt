package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.services.conference.AudioProcessing

class AudioProcessingMapper {
    companion object {
        fun fromMap(map: Map<String, Any?>): AudioProcessing {
            return asMap(map["send"])
                ?.get("audioProcessing")
                ?.takeIf { audioProcessing -> audioProcessing is Boolean && audioProcessing}
                ?.let { AudioProcessing.VOICE }
                ?: AudioProcessing.ENVIRONMENT
        }

        private fun asMap(obj: Any?): Map<String, Any?>? {
            return obj as? Map<String, Any?>

        }
    }
}