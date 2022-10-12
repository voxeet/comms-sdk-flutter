package io.dolby.comms.sdk.flutter.events

import android.os.Handler
import android.os.Looper
import com.voxeet.VoxeetSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin

abstract class NativeEventEmitter(private val eventChannel: EventChannelHandler) {

    private val mainHandler: Handler = Handler(Looper.getMainLooper())

    fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel.onAttached(flutterPluginBinding)
        VoxeetSDK.instance().register(this)
    }

    fun onDetached() {
        VoxeetSDK.instance().unregister(this)
        eventChannel.onDetached()
    }

    // Event needs to be emitted on main thread
    fun emit(key: String, data: Any?) = mainHandler.post {
        eventChannel.emitEvent(key, data)
    }
}
