package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.json.FilePresentationStarted
import com.voxeet.sdk.json.FilePresentationStopped
import com.voxeet.sdk.json.FilePresentationUpdated
import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.services.presentation.file.FilePresentation
import io.dolby.comms.sdk.flutter.events.FilePresentationEventEmitter.FilePresentationEvent.CONVERTED
import io.dolby.comms.sdk.flutter.events.FilePresentationEventEmitter.FilePresentationEvent.STARTED
import io.dolby.comms.sdk.flutter.events.FilePresentationEventEmitter.FilePresentationEvent.STOPPED
import io.dolby.comms.sdk.flutter.events.FilePresentationEventEmitter.FilePresentationEvent.UPDATED
import io.dolby.comms.sdk.flutter.mapper.FilePresentationMapper
import io.dolby.comms.sdk.flutter.state.FilePresentationHolder
import org.greenrobot.eventbus.Subscribe

class FilePresentationEventEmitter(
    eventChannelHandler: EventChannelHandler,
    private val filePresentationHolder: FilePresentationHolder
) : NativeEventEmitter(eventChannelHandler) {

    @Subscribe
    fun on(event: FilePresentationStarted) {
        val presentation = FilePresentation(event.fileId, "").apply {
            nbPage = event.imageCount
            page = event.position
        }

        filePresentationHolder.onStarted(
            conferenceId = event.conferenceId,
            ownerId = event.userId,
            presentation = presentation
        )

        getOwner(event.conferenceId, event.userId)
            ?.also { sendFilePresentationChanged(STARTED, it, presentation) }
    }

    @Subscribe
    fun on(event: FilePresentationStopped) {
        val presentation = filePresentationHolder.onStopped(event.conferenceId) ?: return

        getOwner(event.conferenceId, event.userId)
            ?.also { sendFilePresentationChanged(STOPPED, it, presentation) }
    }

    @Subscribe
    fun on(event: FilePresentationUpdated) {
        val presentation = filePresentationHolder.onSeek(event.conferenceId, event.position) ?: return

        getOwner(event.conferenceId, event.userId)
            ?.also { sendFilePresentationChanged(UPDATED, it, presentation) }
    }

    fun onFileConverted(fileConverted: Map<String, Any>) {
        emit(CONVERTED, fileConverted)
    }

    private fun sendFilePresentationChanged(event: String, owner: Participant, presentation: FilePresentation) {
        FilePresentationMapper(owner, presentation)
            .convertToMap()
            .also { emit(event, it) }
    }

    private fun getOwner(conferenceId: String, participantId: String) = VoxeetSDK.conference()
        .getConference(conferenceId)
        .findParticipantById(participantId)

    private object FilePresentationEvent {
        const val CONVERTED = "EVENT_FILEPRESENTATION_FILE_CONVERTED"
        const val STARTED = "EVENT_FILEPRESENTATION_STARTED"
        const val STOPPED = "EVENT_FILEPRESENTATION_STOPPED"
        const val UPDATED = "EVENT_FILEPRESENTATION_UPDATED"
    }
}
