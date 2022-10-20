package io.dolby.comms.sdk.flutter

import com.voxeet.asserts.*
import io.dolby.comms.sdk.flutter.extension.error
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object MockAssertionClasses {
    private val assertsClasses = mutableListOf<DelegateMethodHandler>()

    fun init(flutterEngine: FlutterEngine) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        assertsClasses.add(DelegateMethodHandler.createChannelFor(VoxeetSDKAssert.create(), messenger))
        assertsClasses.add(DelegateMethodHandler.createChannelFor(SessionServiceAsserts(), messenger))
        assertsClasses.add(DelegateMethodHandler.createChannelFor(ConferenceServiceAsserts(), messenger))
        assertsClasses.add(DelegateMethodHandler.createChannelFor(MediaDeviceServiceAsserts(), messenger))
        assertsClasses.add(DelegateMethodHandler.createChannelFor(NotificationServiceAsserts(), messenger))
        assertsClasses.add(DelegateMethodHandler.createChannelFor(RecordingServiceAsserts(), messenger))
        assertsClasses.add(DelegateMethodHandler.createChannelFor(VideoPresentationServiceAsserts(), messenger))
    }

    fun clear() {
        assertsClasses.forEach {
            it.clearChannel()
        }
    }
}

class DelegateMethodHandler private  constructor(private val methodDelegator: MethodDelegate) : MethodChannel.MethodCallHandler {
    private lateinit var methodChannel: MethodChannel

    fun createChannel(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, methodDelegator.name)
        methodChannel.setMethodCallHandler(this)
    }

    fun clearChannel() {
        methodChannel.setMethodCallHandler(null)
    }

    companion object {
        fun createChannelFor(delegate: MethodDelegate, messenger: BinaryMessenger) : DelegateMethodHandler {
            val delegator = DelegateMethodHandler(delegate)
            delegator.createChannel(messenger)
            return DelegateMethodHandler(delegate)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val assertionResult = object : MethodDelegate.Result {
            override fun success() {
                result.success(listOf(true))
            }

            override fun failed(error: MethodDelegate.AssertionFailed) {
                result.success(listOf<Any>(
                    false,
                    error.actualValue,
                    error.expectedValue,
                    error.errorMsg,
                    error.fileName,
                    error.functionName,
                    error.lineNumber
                ))
            }

            override fun error(throwable: Throwable) {
                result.error(throwable)
            }
        }
        methodDelegator.onAction(call.method, call.arguments(), assertionResult)
    }
}