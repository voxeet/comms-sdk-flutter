package com.voxeet.sdk.services;

import com.voxeet.VoxeetSDK;
import com.voxeet.promise.Promise;

import org.jetbrains.annotations.NotNull;

public class RecordingService {
    public Promise<Boolean> start() {
        return Promise.resolve(true);
    }

    /**
     * Stops recording a conference.
     *
     * @return the promise to resolve that indicates the result of the request.
     */
    public Promise<Boolean> stop() {
        return Promise.resolve(true);
    }
}
