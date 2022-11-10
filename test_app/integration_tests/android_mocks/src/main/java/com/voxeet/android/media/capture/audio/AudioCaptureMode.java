package com.voxeet.android.media.capture.audio;

import com.voxeet.android.media.capture.audio.noise.NoiseReduction;
import com.voxeet.android.media.capture.audio.noise.StandardNoiseReduction;

import org.jetbrains.annotations.NotNull;

public class AudioCaptureMode {
    public Mode mode;
    public NoiseReduction noiseReduction;

    public AudioCaptureMode(Mode mode, NoiseReduction noiseReduction) {
        this.mode = mode;
        this.noiseReduction = noiseReduction;
    }

    @NotNull
    public static AudioCaptureMode standard(StandardNoiseReduction noiseReduction) {
        return new AudioCaptureMode(Mode.STANDARD, noiseReduction.transform());
    }

    @NotNull
    public static AudioCaptureMode unprocessed() {
        return new AudioCaptureMode(Mode.UNPROCESSED, null);
    }
}
