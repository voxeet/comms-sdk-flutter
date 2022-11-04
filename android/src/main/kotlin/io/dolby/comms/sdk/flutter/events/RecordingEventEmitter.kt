package io.dolby.comms.sdk.flutter.events

import com.voxeet.sdk.json.RecordingStatusUpdatedEvent
import com.voxeet.sdk.models.v1.RecordingStatus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class RecordingEventEmitter(eventChannelHandler: EventChannelHandler) : NativeEventEmitter(eventChannelHandler) {
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onRecordingStatusUpdate(event: RecordingStatusUpdatedEvent) {
        mapOf(
            "recordingStatus" to event.recordingStatus,
            "conferenceId" to event.conferenceId,
            "participantId" to event.participantId,
            "timeStamp" to event.timeStamp
        ).let {
            emit(EVENT_RECORDING_STATUS_UPDATED, it)
        }
    }

    companion object {
        const val EVENT_RECORDING_STATUS_UPDATED = "EVENT_RECORDING_STATUS_UPDATED"
    }
}