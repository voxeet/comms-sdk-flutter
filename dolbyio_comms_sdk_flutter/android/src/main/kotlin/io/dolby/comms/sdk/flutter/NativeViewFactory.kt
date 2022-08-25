package io.dolby.comms.sdk.flutter

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val videoViewsChannels: MutableList<MethodChannel> = mutableListOf()

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        val view = NativeView(context!!, viewId)
        createChannelFor(viewId, view)
        return view
    }

    fun onDetachedFromPlugin() {
        videoViewsChannels.forEach {
            it.setMethodCallHandler(null)
        }
        videoViewsChannels.clear()
    }

    private fun createChannelFor(viewId: Int, handler: MethodChannel.MethodCallHandler) {
        val channelName = "video_view_${viewId}_method_channel"
        val channel = MethodChannel(messenger, channelName)
        channel.setMethodCallHandler(handler)
        videoViewsChannels.add(channel)
    }
}
