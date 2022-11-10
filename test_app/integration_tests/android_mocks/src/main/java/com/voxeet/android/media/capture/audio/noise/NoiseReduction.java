package com.voxeet.android.media.capture.audio.noise;

public enum NoiseReduction {
    /**
     * Removes all background sounds to improve voice quality. Use this mode if you want to send only voice to a conference.
     */
    HIGH,
    MEDIUM,
    /**
     * Removes stationary background sounds, such as the sound of a computer fan, air conditioning, or microphone hum, from audio transmitted to a conference. In this mode, non-stationary sounds are transmitted to give participants full context of other participants' environments and create a more realistic audio experience. If you want to send only voice to a conference, use the [High](#high) level.
     */
    LOW
}
