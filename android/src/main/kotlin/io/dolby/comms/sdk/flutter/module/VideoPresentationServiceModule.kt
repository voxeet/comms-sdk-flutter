package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.*
import io.dolby.comms.sdk.flutter.mapper.VideoPresentationMapper
import io.dolby.comms.sdk.flutter.mapper.mapToFlutter
import io.dolby.comms.sdk.flutter.state.VideoPresentationHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope

class VideoPresentationServiceModule(
    private val scope: CoroutineScope,
    private val videoPresentationHolder: VideoPresentationHolder
) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::currentVideo.name -> currentVideo(result)
            ::start.name -> start(call, result)
            ::stop.name -> stop(result)
            ::play.name -> play(result)
            ::pause.name -> pause(call, result)
            ::seek.name -> seek(call, result)
            ::state.name -> state(result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_video_presentation_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun currentVideo(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val presentation = VoxeetSDK.videoPresentation().currentPresentation ?: throw Exception("Couldn't get the presentation")
            val conference = VoxeetSDK.conference().conference ?: throw Exception("Couldn't get the conference")
            val owner = videoPresentationHolder.getOwner(conference.id)
                ?: throw Exception("No started video presentation for current conference")
            result.success(VideoPresentationMapper(owner, presentation.url, presentation.lastSeekTimestamp).convertToMap())
        }
    )

    private fun start(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .videoPresentation()
                .start(call.argumentOrThrow("url"))
                .await()
                .let { result.success(null) }
        }
    )

    private fun stop(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .videoPresentation()
                .stop()
                .await()
                .let { result.success(null) }
        }
    )

    private fun play(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .videoPresentation()
                .play()
                .await()
                .let { result.success(null) }
        }
    )

    private fun pause(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .videoPresentation()
                .pause(call.argumentOrThrow("timestamp"))
                .await()
                .let { result.success(null) }
        }
    )

    private fun seek(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .videoPresentation()
                .seek(call.argumentOrThrow("timestamp"))
                .await()
                .let { result.success(null) }
        }
    )

    private fun state(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .videoPresentation()
                .currentPresentation
                ?.state
                ?.let { result.success(it.mapToFlutter()) }
                ?: throw IllegalStateException("Could not get current presentation")
        }
    )
}
