package com.voxeet.sdk.services.audio;

import com.voxeet.android.media.capture.audio.AudioCaptureMode;
import com.voxeet.promise.Promise;
import com.voxeet.sdk.media.audio.SoundManager;

import org.jetbrains.annotations.NotNull;

public class LocalAudio {
    @NotNull
    public AudioCaptureMode captureMode;
    @NotNull
    public final SoundManager soundManager = new SoundManager();

    @NotNull
    public Promise<Boolean> start() {
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> stop() {
        return Promise.resolve(true);
    }
}
