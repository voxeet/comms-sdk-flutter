package io.dolby.comms.sdk.flutter.events

import com.voxeet.sdk.events.sdk.ConferenceStatusUpdatedEvent
import com.voxeet.sdk.events.sdk.PermissionsUpdatedEvent
import com.voxeet.sdk.events.v2.ParticipantAddedEvent
import com.voxeet.sdk.events.v2.ParticipantUpdatedEvent
import com.voxeet.sdk.events.v2.StreamAddedEvent
import com.voxeet.sdk.events.v2.StreamRemovedEvent
import com.voxeet.sdk.events.v2.StreamUpdatedEvent
import io.dolby.comms.sdk.flutter.mapper.MediaStreamMapper
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

/**
 * The conference event emitter
 */
class ConferenceEventEmitter(eventChannelHandler: EventChannelHandler) : NativeEventEmitter(eventChannelHandler) {

    /**
     * New participant add event
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: ParticipantAddedEvent) {
        emit(ConferenceEvent.PARTICIPANT_ADDED, ParticipantMapper(event.participant).convertToMap())
    }

    /**
     * Existing participant update event
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: ParticipantUpdatedEvent) {
        emit(ConferenceEvent.PARTICIPANT_UPDATED, ParticipantMapper(event.participant).convertToMap())
    }

    /**
     * Current conference status update event
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: ConferenceStatusUpdatedEvent) {
        emit(ConferenceEvent.STATUS_UPDATED, event.state.name)
    }

    /**
     * Emitted when the local participant's permissions are updated.
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: PermissionsUpdatedEvent) {
        emit(ConferenceEvent.PERMISSIONS_UPDATED, event.permissions.map { it.name }.toList())
    }

    /**
     * New stream added event
     *
     * Emitted when the SDK adds a new stream to a conference participant. Each conference participant can be connected to two streams:
     * the `audio and video` stream and the `screen-share` stream. If a participant enables audio or video, the SDK adds the
     * `audio and video` stream to the participant and emits [StreamAddedEvent] to all participants. When a participant is connected to
     * the `audio and video` stream and changes the stream, for example, enables a camera while using a microphone, the SDK updates the
     * `audio and video` stream and emits [StreamUpdatedEvent]. When a participant starts sharing a screen, the SDK adds the
     * `screen-share` stream to this participants and emits [StreamAddedEvent] to all participants. The following
     * [graphic](https://files.readme.io/c729fdb-conference-stream-added.png) shows this behavior.
     *
     * When a new participant joins a conference with enabled audio and video, the SDK emits [StreamAddedEvent] that includes audio and
     * video tracks.
     *
     * The SDK can also emit [StreamAddedEvent] only for the local participant. When the local participant uses the
     * [ConferenceServiceNativeModule.stopAudio] method to locally mute the selected remote participant who does not use a camera, the local
     * participant receives [StreamRemovedEvent]. After using the [ConferenceServiceNativeModule.startAudio] method for this remote
     * participant, the local participant receives [StreamAddedEvent].
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: StreamAddedEvent) {
        mapOf(
            "participant" to ParticipantMapper(event.participant).convertToMap(),
            "stream" to MediaStreamMapper(event.mediaStream).convertToMap()
        ).also { emit(ConferenceEvent.STREAM_ADDED, it) }
    }

    /**
     * Stream removed event
     *
     * Emitted when the SDK removes a stream from a conference participant. Each conference participant can be connected to two streams:
     * the `audio and video` stream and the `screen-share` stream. If a participant disables audio and video or stops a screen-share
     * presentation, the SDK removes the proper stream and emits StreamRemovedEvent to all conference participants.
     *
     * The SDK can also emit [StreamRemovedEvent] only for the local participant. When the local participant uses the
     * [ConferenceServiceNativeModule.stopAudio] method to locally mute a selected remote participant who does not use a camera, the local
     * participant receives [StreamRemovedEvent].
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: StreamRemovedEvent) {
        mapOf(
            "participant" to ParticipantMapper(event.participant).convertToMap(),
            "stream" to MediaStreamMapper(event.mediaStream).convertToMap()
        ).also { emit(ConferenceEvent.STREAM_REMOVED, it) }
    }

    /**
     * Stream update event
     *
     * Emitted when a conference participant who is connected to the `audio and video` stream changes the stream by enabling a microphone
     * while using a camera or by enabling a camera while using a microphone. The event is emitted to all conference participants.
     * The following [graphic](https://files.readme.io/c729fdb-conference-stream-added.png) shows this behavior.
     *
     * The SDK can also emit [StreamUpdatedEvent] only for the local participant. When the local participant uses the
     * [ConferenceServiceNativeModule.stopAudio] or [ConferenceServiceNativeModule.startAudio] method to locally mute or unmute a selected remote
     * participant who uses a camera, the local participant receives [StreamUpdatedEvent].
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: StreamUpdatedEvent) {
        mapOf(
            "participant" to ParticipantMapper(event.participant).convertToMap(),
            "stream" to MediaStreamMapper(event.mediaStream).convertToMap()
        ).also { emit(ConferenceEvent.STREAM_UPDATED, it) }
    }

    /**
     * Conference events
     */
    private object ConferenceEvent {
        const val PERMISSIONS_UPDATED = "EVENT_CONFERENCE_PERMISSIONS_UPDATED"
        const val PARTICIPANT_ADDED = "EVENT_CONFERENCE_PARTICIPANT_ADDED"
        const val PARTICIPANT_UPDATED = "EVENT_CONFERENCE_PARTICIPANT_UPDATED"
        const val STATUS_UPDATED = "EVENT_CONFERENCE_STATUS_UPDATED"
        const val STREAM_ADDED = "EVENT_CONFERENCE_STREAM_ADDED"
        const val STREAM_REMOVED = "EVENT_CONFERENCE_STREAM_REMOVED"
        const val STREAM_UPDATED = "EVENT_CONFERENCE_STREAM_UPDATED"
    }
}
