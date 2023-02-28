package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.*
import io.dolby.comms.sdk.flutter.mapper.ComfortNoiseLevelMapper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope

class MediaDeviceServiceNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::getComfortNoiseLevel.name -> getComfortNoiseLevel(result)
            ::setComfortNoiseLevel.name -> setComfortNoiseLevel(call, result)
            ::isFrontCamera.name -> isFrontCamera(result)
            ::switchCamera.name -> switchCamera(result)
            ::switchSpeaker.name -> switchSpeaker(result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_media_device_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun getComfortNoiseLevel(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.mediaDevice().comfortNoiseLevel.let {
                result.success(ComfortNoiseLevelMapper.convertToString(it))
            }
        }
    )

    private fun setComfortNoiseLevel(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .mediaDevice()
                .setComfortNoiseLevel(ComfortNoiseLevelMapper.convertFromString(call.argumentOrThrow("noiseLevel")))
                .let { result.success(null) }
        }
    )

    private fun isFrontCamera(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.mediaDevice().cameraContext.isDefaultFrontFacing.let {
                result.success(it)
            }
        }
    )

    private fun switchCamera(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.mediaDevice().switchCamera().await().let {
                result.success(it)
            }
        }
    )

    private fun switchSpeaker(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.audio().local.soundManager
                .setSpeakerMode(!VoxeetSDK.audio().local.soundManager.isSpeakerOn)
                .also { result.success(null) }
        }
    )
}
