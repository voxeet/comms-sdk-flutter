package io.dolby.comms.sdk.flutter.module

import android.os.Handler
import android.os.Looper
import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.argumentOrThrow
import io.dolby.comms.sdk.flutter.extension.error
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.extension.onError
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope

class CommsSdkNativeModule(private val scope: CoroutineScope) : NativeModule {

    private val mainHandler: Handler = Handler(Looper.getMainLooper())
    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            ::initialize.name -> initialize(call, result)
            ::initializeToken.name -> initializeToken(call, result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_sdk_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun initialize(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.initialize(
                call.argumentOrThrow("customerKey"),
                call.argumentOrThrow<String>("customerSecret")
            )
            result.success(null)
        }
    )

    private fun initializeToken(call: MethodCall, result: MethodChannel.Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.initialize(call.argumentOrThrow("accessToken")) { _, callback ->
                mainHandler.post {
                    channel.invokeMethod("getRefreshToken", null, object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            (result as? String)?.let { callback.ok(it) } ?: error(Throwable("Refresh token is empty"))
                        }

                        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                            callback.error(Throwable("$errorCode: $errorMessage, $errorDetails"))
                        }

                        override fun notImplemented() {
                            throw IllegalStateException("Method not implemented")
                        }
                    })
                }
            }
            result.success(null)
        }
    )
}
