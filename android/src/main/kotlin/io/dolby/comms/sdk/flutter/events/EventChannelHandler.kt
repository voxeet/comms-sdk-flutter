package io.dolby.comms.sdk.flutter.events

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel

class EventChannelHandler(private val channelName: String) : EventChannel.StreamHandler {

    private lateinit var eventChannel: EventChannel
    private var eventCallback: EventChannel.EventSink? = null

    fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, channelName)
        eventChannel.setStreamHandler(this)
    }

    fun onDetached() {
        eventChannel.setStreamHandler(null)
    }

    fun emitEvent(key: String, data: Any?) {
        eventCallback?.success(mapOf("key" to key, "body" to data))
    }

    override fun onListen(arguments: Any?, callback: EventChannel.EventSink?) {
        eventCallback = callback
    }

    override fun onCancel(arguments: Any?) {
        eventCallback = null
    }
}
