package com.voxeet.asserts

import com.voxeet.VoxeetSDK
import com.voxeet.android.media.capture.audio.AudioCaptureMode
import com.voxeet.android.media.capture.audio.VoiceFont
import com.voxeet.android.media.capture.audio.noise.StandardNoiseReduction
import com.voxeet.android.media.capture.audio.preview.AudioPreviewStatus
import io.dolby.asserts.AssertUtils
import io.dolby.asserts.MethodDelegate
import io.dolby.asserts.MethodDelegate.AssertionFailed
import java.util.concurrent.Callable
import java.util.concurrent.Executors


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
                ::stop.name -> stop()
                ::release.name -> release()
                ::emitStatusChangedEvents.name -> emitStatusChangedEvents()
                ::assertStatusArgs.name -> assertStatusArgs(args)
                ::assertGetCaptureModeArgs.name -> assertGetCaptureModeArgs(args)
                ::assertSetCaptureModeArgs.name -> assertSetCaptureModeArgs(args)
                ::assertRecordArgs.name -> assertRecordArgs(args)
                ::assertPlayArgs.name -> assertPlayArgs(args)
                ::assertStopArgs.name -> assertStopArgs(args)
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
        val mockRunCount = VoxeetSDK.audio().local.preview().statusRunCount
        val hasRun = args?.get("hasRun") ?: throw KeyNotFoundException("hasRun key not found")
        AssertUtils.compareWithExpectedValue(hasRun, mockRunCount > 0, "audio preview status not run")
    }

    private fun assertGetCaptureModeArgs(args: Map<String, Any>?) {
        val mockReturn = VoxeetSDK.audio().local.preview().captureModeReturn
        val hasRun = args?.get("hasRun") ?: throw KeyNotFoundException("hasRun key not found")
        AssertUtils.compareWithExpectedValue(
                hasRun, mockReturn.size < 1, "audio preview get capture mode not run")
    }

    private fun assertSetCaptureModeArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()

        var actualCM = preview.captureModeArgs.removeFirst()
        var expectedCM = AudioCaptureMode.unprocessed()
        AssertUtils.compareWithExpectedValue(actualCM.mode, expectedCM.mode, "Mode is incorrect")
        AssertUtils.compareWithExpectedValue(actualCM.noiseReduction, expectedCM.noiseReduction, "Mode is incorrect")
        AssertUtils.compareWithExpectedValue(actualCM.voiceFont, expectedCM.voiceFont, "Mode is incorrect")

        for (voiceFont in voiceFonts) {
            for (noiseReduction in noiseReductions) {
                actualCM = preview.captureModeArgs.removeFirst()
                expectedCM = AudioCaptureMode.standard(noiseReduction, voiceFont)
                AssertUtils.compareWithExpectedValue(actualCM.mode, expectedCM.mode, "Mode is incorrect")
                AssertUtils.compareWithExpectedValue(actualCM.noiseReduction, expectedCM.noiseReduction, "Mode is incorrect")
                AssertUtils.compareWithExpectedValue(actualCM.voiceFont, expectedCM.voiceFont, "Mode is incorrect")
            }
        }
    }

    private fun assertRecordArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()

        AssertUtils.compareWithExpectedValue<Any?>(
            preview.recordArgs.removeFirst(),
            1,
            "Duration is incorrect"
        )
        AssertUtils.compareWithExpectedValue<Any?>(
                preview.recordArgs.removeFirst(),
                10,
                "Duration is incorrect"
        )
    }

    private fun assertPlayArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        AssertUtils.compareWithExpectedValue<Any?>(
                preview.playModeArgs.removeFirst(),
                true,
                "Loop is incorrect"
        )
        AssertUtils.compareWithExpectedValue<Any?>(
                preview.playModeArgs.removeFirst(),
                false,
                "Loop is incorrect"
        )
    }

    private fun assertStopArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        AssertUtils.compareWithExpectedValue(
                preview.stopRunCount > 0,
                true,
                "audio preview stop not run"
        )
    }

    private fun assertReleaseArgs(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        AssertUtils.compareWithExpectedValue(
                preview.releaseRunCount > 0,
                true,
                "audio preview release not run"
        )
    }

    private fun getStatus() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.statusRunCount = 0;
        preview.statusReturn = audioPreviewStatuses.toMutableList()
    }

    private fun getCaptureMode() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.captureModeReturn.add(AudioCaptureMode.unprocessed());
        for (voiceFont in voiceFonts) {
            for (noiseReduction in noiseReductions) {
                preview.captureModeReturn.add(AudioCaptureMode.standard(noiseReduction, voiceFont));
            }
        }
    }

    private fun setCaptureMode(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        preview.captureModeArgs.clear()
    }

    private fun record(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        preview.recordArgs.clear()
        preview.recordReturn = mutableListOf(true, true)
    }

    private fun play(args: Map<String, Any>?) {
        val preview = VoxeetSDK.audio().local.preview()
        preview.playModeArgs.clear()
        preview.playModeReturn = mutableListOf(true, true)
    }

    private fun stop() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.stopRunCount = 0
        preview.stopReturn = mutableListOf(true)
    }

    private fun release() {
        val preview = VoxeetSDK.audio().local.preview()
        preview.releaseRunCount = 0
        preview.releaseReturn = mutableListOf(true)
    }

    private fun emitStatusChangedEvents() {
        val executorService = Executors.newSingleThreadExecutor()
        val statuses = audioPreviewStatuses.toMutableList()
        lateinit var sendStatusWithDelay: () -> Unit
        sendStatusWithDelay = { ->
            val preview = VoxeetSDK.audio().local.preview()
            executorService.submit(Callable<Void?> {
                Thread.sleep(100)
                val status = statuses.removeFirstOrNull()
                status?.let { s ->
                    preview.onStatusChanged?.let { cb ->
                        cb(s)
                        sendStatusWithDelay()
                    }
                }
                null
            })

        }
        executorService.submit(Callable<Void?> {
            Thread.sleep(1000)
            sendStatusWithDelay()
            null
        })
    }

    override fun getName(): String {
        return "IntegrationTesting.AudioPreviewAsserts"
    }
}

private val audioPreviewStatuses = listOf(
    AudioPreviewStatus.NoRecordingAvailable,
    AudioPreviewStatus.RecordingAvailable,
    AudioPreviewStatus.Recording,
    AudioPreviewStatus.Playing,
    AudioPreviewStatus.Released
);

private val voiceFonts = listOf(
    VoiceFont.NONE,
    VoiceFont.MASCULINE,
    VoiceFont.FEMININE,
    VoiceFont.HELIUM,
    VoiceFont.DARK_MODULATION,
    VoiceFont.BROKEN_ROBOT,
    VoiceFont.INTERFERENCE,
    VoiceFont.ABYSS,
    VoiceFont.WOBBLE,
    VoiceFont.STARSHIP_CAPTAIN,
    VoiceFont.NERVOUS_ROBOT,
    VoiceFont.SWARM,
    VoiceFont.AM_RADIO,
);

private val noiseReductions = listOf(
    StandardNoiseReduction.HIGH, 
    StandardNoiseReduction.LOW
);
