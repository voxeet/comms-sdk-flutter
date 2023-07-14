package com.voxeet.android.media.capture.audio.preview

import androidx.annotation.IntRange
import com.voxeet.android.media.capture.audio.AudioCaptureMode
import com.voxeet.promise.Promise

class AudioPreview {
    var statusHasRun = false;
    var setCaptureModeHasRun = false;
    var getCaptureModeHasRun = false;
    var recordHasRun = false;
    var playHasRun = false;
    var cancelHasRun = false;
    var releaseHasRun = false;

    var setCaptureModeArgs: Map<String, Any>? = null
    var recordArgs: Map<String, Any>? = null
    var playArgs: Map<String, Any>? = null

    var captureMode: AudioCaptureMode = AudioCaptureMode.unprocessed()
        set(value) {
            field = value
        }

    var status: RecorderStatus = RecorderStatus.NoRecordingAvailable
        private set(value) {
            val oldStatus = field
            field = value

            if (oldStatus != value) {
                callback?.let { it(value) }
            }
        }

    var callback: ((status: RecorderStatus) -> Unit)? = null

    /**
     * Start recording if no record or playout is pending
     */
    @Suppress("MagicNumber")
    fun record(@IntRange(0, 5) duration: Int): Promise<Boolean> {
        return Promise { solver ->
            status = RecorderStatus.Recording
            solver.resolve(true)
        }
    }

    /**
     * Start playing the audio if no other playout or record is pending
     */
    fun play(loop: Boolean): Promise<Boolean> {
        return Promise { solver ->
            status = RecorderStatus.Playing
            solver.resolve(true)
        }
    }

    /**
     * Cancel any record or play that may be pending
     */
    fun cancel(): Boolean {
        status = RecorderStatus.NoRecordingAvailable
        return true
    }

    /**
     * Release the internal memory used by the JNI interface
     */
    fun release(): Boolean {
        status = RecorderStatus.Released
        return true
    }
}