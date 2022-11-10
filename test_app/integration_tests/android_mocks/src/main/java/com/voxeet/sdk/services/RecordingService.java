package com.voxeet.sdk.services;

import com.voxeet.VoxeetSDK;
import com.voxeet.promise.Promise;

import org.jetbrains.annotations.NotNull;

public class RecordingService {

    public boolean startHasRun = false;
    public Promise<Boolean> start() {
        startHasRun = true;
        return Promise.resolve(true);
    }

    /**
     * Stops recording a conference.
     *
     * @return the promise to resolve that indicates the result of the request.
     */
    public boolean stopHasRun = false;
    public Promise<Boolean> stop() {
        stopHasRun = true;
        return Promise.resolve(true);
    }
}
