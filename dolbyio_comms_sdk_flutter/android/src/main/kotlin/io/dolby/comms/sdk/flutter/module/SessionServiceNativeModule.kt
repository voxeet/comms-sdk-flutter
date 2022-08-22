package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.json.ParticipantInfo
import io.dolby.comms.sdk.flutter.extension.argumentOrThrow
import io.dolby.comms.sdk.flutter.extension.await
import io.dolby.comms.sdk.flutter.extension.error
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren

class SessionServiceNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::open.name -> open(call, result)
            ::close.name -> close(result)
            ::isOpen.name -> isOpen(result)
            ::getParticipant.name -> getParticipant(result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_session_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
        scope.coroutineContext.cancelChildren(null)
    }

    private fun open(call: MethodCall, result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            val participantInfo = ParticipantInfo(
                call.argumentOrThrow("name"),
                call.argument("avatarUrl"),
                call.argument("externalId")
            )
            VoxeetSDK.session().open(participantInfo).await().let { result.success(it) }
        }
    )

    private fun close(result: Result) = scope.launch(
        onError = result::error,
        onSuccess = { VoxeetSDK.session().close().await().let { result.success(it) } }
    )

    private fun isOpen(result: Result) = result.success(VoxeetSDK.session().isOpen)

    private fun getParticipant(result: Result) = VoxeetSDK
        .session()
        .participant
        ?.let { result.success(ParticipantMapper(it).convertToMap()) }
        ?: result.error(IllegalStateException("Participant not found, is session open?"))
}
