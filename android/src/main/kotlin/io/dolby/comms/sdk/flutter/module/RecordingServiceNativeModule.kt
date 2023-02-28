package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.json.ParticipantInfo
import io.dolby.comms.sdk.flutter.extension.*
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import io.dolby.comms.sdk.flutter.mapper.RecordingInformationMapper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancelChildren

class RecordingServiceNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::start.name -> start(result)
            ::stop.name -> stop(result)
            ::currentRecording.name -> currentRecording(result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_recording_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun start(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = { VoxeetSDK.recording().start().await().let { result.success(null) }  }
    )

    private fun stop(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = { VoxeetSDK.recording().stop().await().let { result.success(null) } }
    )

    private fun currentRecording(result: Result) = VoxeetSDK
        .conference()
        .conference
        ?.recordingInformation
        ?.let { result.success(RecordingInformationMapper(it).convertToMap()) }
        ?: result.error(IllegalStateException("Could not get recording information"))
}
