package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.Conference

class RecordingInformationMapper(private val recordingInformation: Conference.RecordingInformation) : Mapper() {
    override fun convertToMap(): Map<String, Any?> = mapOf(
        "participantId" to recordingInformation.recordingParticipant,
        "startTimestamp" to recordingInformation.startRecordTimestamp.time,
        "recordingStatus" to recordingInformation.recordingStatus.name
    )
}
