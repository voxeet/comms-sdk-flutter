package com.voxeet.sdk.services.video;

import androidx.annotation.NonNull;

import com.voxeet.promise.Promise;

public class LocalVideo {
    public boolean startHasRun = false;
    public boolean stopHasRun = false;

    public Promise<Boolean> start() {
        startHasRun = true;
        return Promise.resolve(true);
    }


    public Promise<Boolean> start(boolean isDefaultFrontFacing) {
        startHasRun = true;
        return Promise.resolve(true);
    }


    public Promise<Boolean> stop() {
        stopHasRun = true;
        return Promise.resolve(true);
    }
}
