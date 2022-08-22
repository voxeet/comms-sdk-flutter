package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.json.VideoPresentationPaused
import com.voxeet.sdk.json.VideoPresentationPlay
import com.voxeet.sdk.json.VideoPresentationSeek
import com.voxeet.sdk.json.VideoPresentationStarted
import com.voxeet.sdk.json.VideoPresentationStopped
import io.dolby.comms.sdk.flutter.mapper.VideoPresentationMapper
import io.dolby.comms.sdk.flutter.state.VideoPresentationHolder
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode.MAIN

/**
 * The video presentation event emitter
 */
class VideoPresentationEventEmitter(
    eventChannelHandler: EventChannelHandler,
    private val videoPresentationHolder: VideoPresentationHolder
) : NativeEventEmitter(eventChannelHandler) {

    /**
     * Emitted when the presenter starts sharing a video.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: VideoPresentationStarted) {
        val participant = VoxeetSDK.conference().findParticipantById(event.participantId) ?: return

        videoPresentationHolder.onStarted(
            conferenceId = event.conferenceId,
            owner = participant
        )

        VideoPresentationMapper(participant, event.url, event.timestamp)
            .convertToMap()
            .also { emit(VideoPresentationEvent.STARTED, it) }
    }

    /**
     * Emitted when the presenter pauses the shared video.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: VideoPresentationPaused) {
        val participant = VoxeetSDK.conference().findParticipantById(event.participantId) ?: return
        val url = VoxeetSDK.videoPresentation().currentPresentation?.url ?: return

        VideoPresentationMapper(participant, url, event.timestamp)
            .convertToMap()
            .also { emit(VideoPresentationEvent.PAUSED, it) }
    }

    /**
     * Emitted when the presenter resumes the video presentation.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: VideoPresentationPlay) {
        val participant = VoxeetSDK.conference().findParticipantById(event.participantId) ?: return
        val url = VoxeetSDK.videoPresentation().currentPresentation?.url ?: return

        VideoPresentationMapper(participant, url, event.timestamp)
            .convertToMap()
            .also { emit(VideoPresentationEvent.PLAYED, it) }
    }

    /**
     * Emitted when the presenter changes the timestamp of the displayed video.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: VideoPresentationSeek) {
        val participant = VoxeetSDK.conference().findParticipantById(event.participantId) ?: return
        val url = VoxeetSDK.videoPresentation().currentPresentation?.url ?: return

        VideoPresentationMapper(participant, url, event.timestamp)
            .convertToMap()
            .also { emit(VideoPresentationEvent.SOUGHT, it) }
    }

    /**
     * Emitted when the presenter stops sharing a video.
     */
    @Subscribe(threadMode = MAIN)
    fun on(event: VideoPresentationStopped) {
        videoPresentationHolder.onStopped(event.conferenceId)

        emit(VideoPresentationEvent.STOPPED, null)
    }

    /**
     * Video presentation events
     */
    private object VideoPresentationEvent {
        const val STARTED = "EVENT_VIDEOPRESENTATION_STARTED"
        const val PAUSED = "EVENT_VIDEOPRESENTATION_PAUSED"
        const val PLAYED = "EVENT_VIDEOPRESENTATION_PLAYED"
        const val SOUGHT = "EVENT_VIDEOPRESENTATION_SOUGHT"
        const val STOPPED = "EVENT_VIDEOPRESENTATION_STOPPED"
    }
}
