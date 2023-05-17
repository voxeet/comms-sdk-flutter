package com.voxeet.android.media.capture.audio;

import com.voxeet.android.media.capture.audio.noise.NoiseReduction;
import com.voxeet.android.media.capture.audio.noise.StandardNoiseReduction;

import org.jetbrains.annotations.NotNull;

public class AudioCaptureMode {
    public Mode mode;
    public NoiseReduction noiseReduction;
    public VoiceFont voiceFont;

    public AudioCaptureMode(Mode mode, NoiseReduction noiseReduction) {
        this(mode, noiseReduction, VoiceFont.NONE);
    }

    public AudioCaptureMode(Mode mode, NoiseReduction noiseReduction, VoiceFont voiceFont) {
        this.mode = mode;
        this.noiseReduction = noiseReduction;
        this.voiceFont = voiceFont;
    }

    @NotNull
    public static AudioCaptureMode standard(StandardNoiseReduction noiseReduction) {
        return new AudioCaptureMode(Mode.STANDARD, noiseReduction.transform(), VoiceFont.NONE);
    }

    @NotNull
    public static AudioCaptureMode standard(StandardNoiseReduction noiseReduction, VoiceFont voiceFont) {
        return new AudioCaptureMode(Mode.STANDARD, noiseReduction.transform());
    }

    @NotNull
    public static AudioCaptureMode unprocessed() {
        return new AudioCaptureMode(Mode.UNPROCESSED, null);
    }
}
