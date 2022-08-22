package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin

abstract class NativeEventEmitter(private val handler: EventChannelHandler)  {

    fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        handler.onAttached(flutterPluginBinding)
        VoxeetSDK.instance().register(this)
    }

    fun onDetached() {
        VoxeetSDK.instance().unregister(this)
        handler.onDetached()
    }

    fun emit(key: String, data: Any?) {
        handler.emitEvent(key, data)
    }
}
