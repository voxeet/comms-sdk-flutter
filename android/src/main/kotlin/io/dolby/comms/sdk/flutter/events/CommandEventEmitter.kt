package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.events.sdk.MessageReceived
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

/**
 * The command event emitter
 */
class CommandEventEmitter(eventChannelHandler: EventChannelHandler) : NativeEventEmitter(eventChannelHandler) {

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun on(event: MessageReceived) {
        VoxeetSDK
            .conference()
            .findParticipantById(event.participantId)
            ?.let { ParticipantMapper(it).convertToMap() }
            ?.let {
                mapOf<String, Any?>(
                    "participant" to it,
                    "message" to event.message
                )
            }
            ?.let { emit(CommandEvent.MESSAGE_RECEIVED, it) }
    }

    /**
     * Command events
     */
    private object CommandEvent {
        const val MESSAGE_RECEIVED = "EVENT_COMMAND_MESSAGE_RECEIVED"
    }
}
