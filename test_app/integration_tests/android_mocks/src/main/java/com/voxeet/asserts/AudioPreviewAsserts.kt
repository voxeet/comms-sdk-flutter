package com.voxeet.asserts

import com.voxeet.VoxeetSDK
import io.dolby.asserts.AssertUtils
import io.dolby.asserts.MethodDelegate
import io.dolby.asserts.MethodDelegate.AssertionFailed

class AudioPreviewAsserts : MethodDelegate {
    override fun onAction(
        methodName: String?,
        args: MutableMap<String, Any>?,
        result: MethodDelegate.Result?
    ) {
        try {
            when (methodName) {
                ::getStatus.name -> getStatus()
                ::getCaptureMode.name -> getCaptureMode()
                ::setCaptureMode.name -> setCaptureMode(args)
                ::record.name -> record(args)
                ::play.name -> play(args)
                ::cancel.name -> cancel()
                ::release.name -> release()
                ::assertStatusArgs.name -> assertStatusArgs(args)
                ::assertGetCaptureModeArgs.name -> assertGetCaptureModeArgs(args)
                ::assertSetCaptureModeArgs.name -> assertSetCaptureModeArgs(args)
                ::assertRecordArgs.name -> assertRecordArgs(args)
                ::assertPlayArgs.name -> assertPlayArgs(args)
                ::assertCancelArgs.name -> assertCancelArgs(args)
                ::assertReleaseArgs.name -> assertReleaseArgs(args)
                else -> {
                    result!!.error(NoSuchMethodError("Method: $methodName not found in $name method channel"))
                    return
                }
            }
            result!!.success()
        } catch (exception: AssertionFailed) {
            result!!.failed(exception)
        } catch (ex: Exception) {
            result!!.error(ex)
        }
    }

    private fun assertStatusArgs(args: Map<String, Any>?) {
        val mockHasRun = VoxeetSDK.audio().local.preview().statusHasRun
        val hasRun = args?.get("hasRun") ?: throw KeyNotFoundException("hasRun key not found")

        AssertUtils.compareWithExpectedValue(
            mockHasRun,
            hasRun,
            "audio preview status not run"
        )
    }

    private fun assertGetCaptureModeArgs(args: Map<String, Any>?) {
        val mockHasRun = VoxeetSDK.audio().local.preview().statusHasRun
        val hasRun = args?.get("hasRun") ?: throw KeyNotFoundException("hasRun key not found")
        AssertUtils.compareWithExpectedValue(
            mockHasRun,
            hasRun,
            "audio preview get capture mode not run"
        )
    }

    private fun assertSetCaptureModeArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        val calledArgs: Map<String, Any> =
            preview.setCaptureModeArgs ?: throw NullPointerException("setCaptureModeArgs is null")
        val mode = args?.get("mode") ?: throw KeyNotFoundException("Key: mode not found")
        val noiseReduction = args["noiseReduction"]
            ?: throw KeyNotFoundException("Key: noiseReduction not found")
        val voiceFont =
            args["voiceFont"] ?: throw KeyNotFoundException("Key: voiceFont not found")

        AssertUtils.compareWithExpectedValue<Any?>(
            calledArgs["mode"],
            mode,
            "Mode is incorrect"
        )

        AssertUtils.compareWithExpectedValue<Any?>(
            calledArgs["noiseReduction"],
            noiseReduction,
            "NoiseReduction is incorrect"
        )

        AssertUtils.compareWithExpectedValue<Any?>(
            calledArgs["voiceFont"],
            voiceFont,
            "VoiceFont is incorrect"
        )
    }

    private fun assertRecordArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        val calledArgs: Map<String, Any> =
            preview.recordArgs ?: throw NullPointerException("recordArgs is null");
        val duration = args?.get("duration") ?: throw KeyNotFoundException("Key: duration not found")

        AssertUtils.compareWithExpectedValue<Any?>(
            calledArgs["duration"],
            duration,
            "Duration is incorrect"
        )
    }

    private fun assertPlayArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        val calledArgs: Map<String, Any> =
            preview.playArgs ?: throw NullPointerException("playArgs is null")
        val loop = args?.get("loop") ?: throw KeyNotFoundException("Key: loop not found")
        AssertUtils.compareWithExpectedValue<Any?>(
            calledArgs["loop"],
            loop,
            "Loop is incorrect"
        )

    }

    private fun assertCancelArgs(args: Map<String, Any>?) {
        val mockHasRun = VoxeetSDK.audio().local.preview().cancelHasRun
        if (args!!.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(
                mockHasRun,
                args!!["hasRun"],
                "audio preview cancel not run"
            )
        } else {
            throw KeyNotFoundException("hasRun key not found")
        }
    }

    private fun assertReleaseArgs(args: Map<String, Any>?) {
        val mockHasRun = VoxeetSDK.audio().local.preview().releaseHasRun
        if (args!!.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(
                mockHasRun,
                args!!["hasRun"],
                "audio preview release not run"
            )
        } else {
            throw KeyNotFoundException("hasRun key not found")
        }
    }

    private fun getStatus() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.statusHasRun = true;
    }

    private fun getCaptureMode() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.getCaptureModeHasRun = true;
    }

    private fun setCaptureMode(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        preview.setCaptureModeHasRun = true
        preview.setCaptureModeArgs = args
    }

    private fun record(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        preview.recordHasRun = true
        preview.recordArgs = args
    }

    private fun play(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        preview.playHasRun = true
        preview.playArgs = args
    }

    private fun cancel() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.cancelHasRun = true
    }

    private fun release() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.releaseHasRun = true
    }

    override fun getName(): String {
        return "IntegrationTesting.AudioPreviewAsserts"
    }
}