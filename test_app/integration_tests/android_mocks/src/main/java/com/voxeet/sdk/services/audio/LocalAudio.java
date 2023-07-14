package com.voxeet.sdk.services.audio;

import com.voxeet.android.media.capture.audio.AudioCaptureMode;
import com.voxeet.android.media.capture.audio.preview.AudioPreview;
import com.voxeet.promise.Promise;
import com.voxeet.sdk.media.audio.SoundManager;

import org.jetbrains.annotations.NotNull;

public class LocalAudio {
    private final AudioPreview previewInstance = new AudioPreview();

    public boolean startHasRun = false;
    public boolean stopHasRun = false;
    public boolean getComfortNoiseHasRun = false;
    @NotNull
    public AudioCaptureMode captureMode;
    @NotNull
    public final SoundManager soundManager = new SoundManager();

    @NotNull
    public Promise<Boolean> start() {
        startHasRun = true;
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> stop() {
        stopHasRun = true;
        return Promise.resolve(true);
    }

    @NotNull
    public AudioPreview preview() {
        return previewInstance;
    }
}
