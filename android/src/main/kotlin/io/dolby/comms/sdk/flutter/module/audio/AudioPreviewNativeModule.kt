package io.dolby.comms.sdk.flutter.module.audio

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.argumentOrThrow
import io.dolby.comms.sdk.flutter.extension.await
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.extension.onError
import io.dolby.comms.sdk.flutter.mapper.AudioCaptureModeMapper
import io.dolby.comms.sdk.flutter.module.NativeModule
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import java.lang.reflect.Proxy

class AudioPreviewNativeModule(private val scope: CoroutineScope) : NativeModule {
    private lateinit var channel: MethodChannel

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_audio_preview_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            ::status.name -> status(result)
            ::getCaptureMode.name -> getCaptureMode(result)
            ::setCaptureMode.name -> setCaptureMode(call, result)
            ::record.name -> record(call, result)
            ::play.name -> play(call, result)
            ::cancel.name -> cancel(result)
            ::release.name -> release(result)
        }
    }

    private fun status(result: MethodChannel.Result)  = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.audio().local.preview().status.let {
                result.success(it.name)
            }
        }
    )

    private fun getCaptureMode(result: MethodChannel.Result)  = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.audio().local.preview().captureMode.let {
                result.success(AudioCaptureModeMapper(it).convertToMap())
            }
        }
    )

    private fun setCaptureMode(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.audio().local.preview().captureMode = AudioCaptureModeMapper.fromMap(call.arguments as Map<String, Any?>)
            result.success(null)
        }
    )

    private fun record(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            call.argumentOrThrow<Int>("duration").let { duration ->
                VoxeetSDK.audio().local.preview().record(duration).await()
                result.success(null)
            }
        }
    )

    private fun play(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            call.argumentOrThrow<Boolean>("loop").let { loop ->
                VoxeetSDK.audio().local.preview().play(loop).await()
                result.success(null)
            }
        }
    )

    private fun cancel(result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            result.success(VoxeetSDK.audio().local.preview().cancel())
        }
    )

    private fun release(result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            result.success(VoxeetSDK.audio().local.preview().release())
        }
    )
}