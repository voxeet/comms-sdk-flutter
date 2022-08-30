package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.android.media.MediaStream
import com.voxeet.sdk.json.ParticipantInfo
import com.voxeet.sdk.models.Conference
import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.push.center.invitation.InvitationBundle

abstract class Mapper {

    abstract fun convertToMap(): Map<String, Any?>

    companion object {
        fun <T : Any> of(obj: T): Mapper? {
            return createMapperForType(obj)
        }

        private fun <T : Any> createMapperForType(obj: T): Mapper? {
            return when (obj) {
                is Conference -> ConferenceMapper(obj)
                is Participant -> ParticipantMapper(obj)
                is ParticipantInfo -> ParticipantInfoMapper(obj)
                is Map<*, *> -> MapSupportTypeMapper(obj as Map<Any, Any?>)
                is InvitationBundle -> InvitationBundleMapper(obj)
                is MediaStream -> MediaStreamMapper(obj)
                else -> null
            }
        }
    }
}
