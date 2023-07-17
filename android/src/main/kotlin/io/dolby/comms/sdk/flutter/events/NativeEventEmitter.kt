package io.dolby.comms.sdk.flutter.events

import android.os.Handler
import android.os.Looper
import com.voxeet.VoxeetSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin

abstract class NativeEventEmitter(private val eventChannel: EventChannelHandler) {

    private val mainHandler: Handler = Handler(Looper.getMainLooper())

    fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel.onAttached(flutterPluginBinding)
        registerEventEmitter()
    }

    fun onDetached() {
        unregisterEventEmitter()
        eventChannel.onDetached()
    }

    // Event needs to be emitted on main thread
    fun emit(key: String, data: Any?) = mainHandler.post {
        eventChannel.emitEvent(key, data)
    }

    protected open fun registerEventEmitter() {
        VoxeetSDK.instance().register(this)
    }

    protected open fun unregisterEventEmitter() {
        VoxeetSDK.instance().unregister(this)
    }
}
