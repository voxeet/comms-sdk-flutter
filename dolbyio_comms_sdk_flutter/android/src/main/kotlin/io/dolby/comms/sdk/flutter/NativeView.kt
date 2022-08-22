package io.dolby.comms.sdk.flutter

import com.voxeet.sdk.views.VideoView
import android.content.Context
import android.view.View
import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.mapper.MediaStreamMapper
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class NativeView(context: Context, id: Int, messenger: BinaryMessenger): PlatformView, MethodChannel.MethodCallHandler {

    private val videoView: VideoView
    private val channel: MethodChannel

    override fun getView(): VideoView {
        return videoView
    }

    init {
        videoView = VideoView(context)
        videoView.id = id
        channel = MethodChannel(messenger, "video_view_${id}_method_channel")
        channel.setMethodCallHandler(this)
    }

    override fun dispose() {
        videoView.unAttach()
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        channel.setMethodCallHandler(null)
    }

    fun isAttached(result: MethodChannel.Result) {
        result.success(videoView.isAttached)
    }

    fun isScreenShare(result: MethodChannel.Result) {
        result.success(videoView.isScreenShare)
    }

    fun attach(arguments: Map<Any?, Any?>?, result: MethodChannel.Result) {
        arguments?.let { args ->

            val participantId = arguments?.get("participant_id") as String?
            val mediaStreamLabel = arguments?.get("media_stream_label") as String?

            if (participantId != null && mediaStreamLabel != null) {
                VoxeetSDK.conference()
                    .findParticipantById(participantId)
                    ?.streams()
                    ?.firstOrNull { it.label() == mediaStreamLabel }
                    ?.let { videoView.attach(participantId, it) } ?: videoView.unAttach()
            } else {
                videoView.unAttach()
            }

            result.success(null)

        } ?: result.error("INVALID_ARGUMENTS", "Invalid arguments for attach method: $arguments", null)
    }

    fun detach(result: MethodChannel.Result) {
        videoView.unAttach()
        result.success(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            ::isAttached.name -> isAttached(result)
            ::isScreenShare.name -> isScreenShare(result)
            ::attach.name -> attach(call.arguments as? Map<Any?, Any?>, result)
            ::detach.name -> detach(result)
            else -> result.notImplemented()
        }
    }
}
