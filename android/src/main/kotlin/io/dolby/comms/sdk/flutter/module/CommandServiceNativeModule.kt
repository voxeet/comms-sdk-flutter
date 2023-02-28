package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope

class CommandServiceNativeModule(private val scope: CoroutineScope) : NativeModule {
    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::send.name -> send(call, result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_command_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun send(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.conference().conferenceId?.let { id ->
                val message = call.argumentOrThrow<String>("message")
                VoxeetSDK.command().send(id, message).await().let { result.success(it) }
            } ?: throw Exception("Conference ID not found, are you in a conference?")
        }
    )
}
