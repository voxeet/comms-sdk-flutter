package io.dolby.comms.sdk.flutter.module.audio

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.await
import io.dolby.comms.sdk.flutter.extension.error
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.extension.onError
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import io.dolby.comms.sdk.flutter.module.NativeModule
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope

class RemoteAudioNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::start.name -> start(call, result)
            ::stop.name -> stop(call, result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_remote_audio_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun start(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ParticipantMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let { VoxeetSDK.audio().remote.start(it).await() }
                ?.let { require(it) { "Could not start audio" } }
                ?.also { result.success(null) }
                ?: throw IllegalStateException("Could not find participant")
        }
    )

    private fun stop(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ParticipantMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let { VoxeetSDK.audio().remote.stop(it).await() }
                ?.let { require(it) { "Could not stop audio" } }
                ?.also { result.success(null) }
                ?: throw IllegalStateException("Could not find participant")
        }
    )
}
