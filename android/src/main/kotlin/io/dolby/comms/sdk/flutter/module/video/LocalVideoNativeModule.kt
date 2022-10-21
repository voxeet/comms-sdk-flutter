package io.dolby.comms.sdk.flutter.module.video

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.await
import io.dolby.comms.sdk.flutter.extension.error
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.module.NativeModule
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancelChildren

class LocalVideoNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::start.name -> start(result)
            ::stop.name -> stop(result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_local_video_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
        scope.coroutineContext.cancelChildren(null)
    }

    private fun start(result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            VoxeetSDK.video().local.start().await()
                ?.let { require(it) { "Could not stop audio" } }
                .also { result.success(null) }
        }
    )

    private fun stop(result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            VoxeetSDK.video().local.stop().await()
                ?.let { require(it) { "Could not stop audio" } }
                .also { result.success(null) }
        }
    )
}
