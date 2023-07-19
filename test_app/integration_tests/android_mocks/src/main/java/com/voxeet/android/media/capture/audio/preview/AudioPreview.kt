package com.voxeet.android.media.capture.audio.preview

import androidx.annotation.IntRange
import com.voxeet.android.media.capture.audio.AudioCaptureMode
import com.voxeet.promise.Promise

class AudioPreview {

    var captureModeArgs = mutableListOf<AudioCaptureMode>()
    var captureModeReturn = mutableListOf<AudioCaptureMode>()
    var captureMode: AudioCaptureMode
        get() {
            return captureModeReturn.removeFirst()
        }
        set(newValue: AudioCaptureMode) {
            captureModeArgs.add(newValue)
        }

    var statusRunCount: Int = 0
    var statusReturn = mutableListOf<RecorderStatus>()
    var status: RecorderStatus
        get() {
            statusRunCount++
            return statusReturn.removeAt(0)
        }
        private set(newValue: RecorderStatus) { }


    var callback: ((status: RecorderStatus) -> Unit)? = null


    var recordArgs = mutableListOf<Int>()
    var recordReturn = mutableListOf<Boolean>()
    fun record(@IntRange(0, 5) duration: Int): Promise<Boolean> {
        recordArgs.add(duration)
        return Promise { solver ->
            solver.resolve(recordReturn.removeFirst())
        }
    }

    var playModeArgs = mutableListOf<Boolean>()
    var playModeReturn = mutableListOf<Boolean>()
    fun play(loop: Boolean): Promise<Boolean> {
        playModeArgs.add(loop)
        return Promise { solver ->
            solver.resolve(playModeReturn.removeFirst())
        }
    }

    var cancelRunCount: Int = 0
    var cancelReturn = mutableListOf<Boolean>()
    fun cancel(): Boolean {
        cancelRunCount++
        return cancelReturn.removeFirst()
    }

    var releaseRunCount: Int = 0
    var releaseReturn = mutableListOf<Boolean>()
    fun release(): Boolean {
        releaseRunCount++
        return releaseReturn.removeFirst()
    }
}
