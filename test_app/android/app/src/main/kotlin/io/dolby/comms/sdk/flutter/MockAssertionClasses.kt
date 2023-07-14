package io.dolby.comms.sdk.flutter

import io.dolby.asserts.MethodDelegate
import io.dolby.comms.sdk.flutter.extension.error
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object MockAssertionClasses {
    private val assertsClasses = mutableListOf<DelegateMethodHandler>()

    fun init(flutterEngine: FlutterEngine) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        try {
            DelegateMethodHandler.createChannelFor("com.voxeet.asserts.VoxeetSDKAssert", messenger)
                ?.let {
                    assertsClasses.add(it)
                }
            DelegateMethodHandler.createChannelFor(
                "com.voxeet.asserts.SessionServiceAsserts",
                messenger
            )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.ConferenceServiceAsserts",
                    messenger
                )?.let {
                    assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.MediaDeviceServiceAsserts",
                    messenger
                )?.let {
                    assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.NotificationServiceAsserts",
                    messenger
                )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.RecordingServiceAsserts",
                    messenger
            )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.VideoPresentationServiceAsserts",
                    messenger
                )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.FilePresentationServiceAsserts",
                    messenger
                )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                    "com.voxeet.asserts.CommandServiceAsserts",
                    messenger
                )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                "com.voxeet.asserts.AudioServiceAsserts",
                messenger
            )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                "com.voxeet.asserts.VideoServiceAsserts",
                messenger
            )?.let {
                assertsClasses.add(it)
            }
            DelegateMethodHandler.createChannelFor(
                "com.voxeet.asserts.AudioPreviewAsserts",
                messenger
            )?.let {
                assertsClasses.add(it)
            }
        } catch (e: ClassNotFoundException) {
            android.util.Log.d("[KB]", "missing assertion classed, for mock it will be a problem")
        }
    }

    fun clear() {
        assertsClasses.forEach {
            it.clearChannel()
        }
    }
}

class DelegateMethodHandler private constructor(private val methodDelegator: MethodDelegate) : MethodChannel.MethodCallHandler {
    private lateinit var methodChannel: MethodChannel

    fun createChannel(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, methodDelegator.name)
        methodChannel.setMethodCallHandler(this)
    }

    fun clearChannel() {
        methodChannel.setMethodCallHandler(null)
    }

    companion object {
        fun createChannelFor(delegateClass: String, messenger: BinaryMessenger) : DelegateMethodHandler? {
            return Class.forName(delegateClass).let { delegate ->
                val delegator = DelegateMethodHandler(delegate.newInstance() as MethodDelegate)
                delegator.createChannel(messenger)
                delegator
            }
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