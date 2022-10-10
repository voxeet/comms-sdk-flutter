package com.voxeet.sdk.services;

import androidx.annotation.NonNull;

import com.voxeet.android.media.camera.CameraContext;
import com.voxeet.android.media.errors.MediaEngineException;
import com.voxeet.android.media.MediaEngine.ComfortNoiseLevel;
import com.voxeet.promise.Promise;

import org.jetbrains.annotations.NotNull;

public class MediaDeviceService {
    public ComfortNoiseLevel level = ComfortNoiseLevel.DEFAULT;
    public void setComfortNoiseLevel(ComfortNoiseLevel level) throws MediaEngineException {
        this.level = level;
    }

    public Boolean getComfortNoiseLevelHasRun = false;
    public ComfortNoiseLevel getComfortNoiseLevel() throws MediaEngineException {
        getComfortNoiseLevelHasRun = true;
        return level;
    }

    @NonNull
    public CameraContext getCameraContext() {
        return new CameraContext();
    }

    public Boolean switchCameraHasRun = false;
    public Promise<Boolean> switchCamera() {
        switchCameraHasRun = true;
        return Promise.resolve(true);
    }
}
