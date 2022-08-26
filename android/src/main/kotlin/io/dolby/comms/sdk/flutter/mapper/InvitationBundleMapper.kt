package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.push.center.invitation.InvitationBundle

class InvitationBundleMapper(private val obj: InvitationBundle) : Mapper() {
    override fun convertToMap() = obj.conferenceId?.let { id ->
        val conference = VoxeetSDK.conference().getConference(id)
        val token = obj.inviter.id?.let { pId -> VoxeetSDK.conference().findParticipantById(pId) }?.let { obj.inviter.id }
        mapOf(
            "conferenceId" to obj.conferenceId,
            "conferenceAlias" to conference.alias,
            "conferenceToken" to (token ?: "")
        )
    } ?: emptyMap()

}
