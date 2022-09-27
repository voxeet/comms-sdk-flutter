package com.voxeet.sdk.services;

import androidx.annotation.NonNull;

import com.voxeet.android.media.camera.CameraContext;
import com.voxeet.android.media.errors.MediaEngineException;
import com.voxeet.android.media.MediaEngine.ComfortNoiseLevel;
import com.voxeet.promise.Promise;

import org.jetbrains.annotations.NotNull;

public class MediaDeviceService {
    private ComfortNoiseLevel level = ComfortNoiseLevel.OFF;
    public void setComfortNoiseLevel(ComfortNoiseLevel level) throws MediaEngineException {
        this.level = level;
    }

    public ComfortNoiseLevel getComfortNoiseLevel() throws MediaEngineException {
        return level;
    }

    @NonNull
    public CameraContext getCameraContext() {
        return new CameraContext();
    }

    public Promise<Boolean> switchCamera() {
        return Promise.resolve(true);
    }
}
