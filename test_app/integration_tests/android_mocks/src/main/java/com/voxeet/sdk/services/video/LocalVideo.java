package com.voxeet.sdk.services.video;

import androidx.annotation.NonNull;

import com.voxeet.promise.Promise;

public class LocalVideo {


    public Promise<Boolean> start() {
        return Promise.resolve(true);
    }


    public Promise<Boolean> start(boolean isDefaultFrontFacing) {
        return Promise.resolve(true);
    }


    public Promise<Boolean> stop() {
        return Promise.resolve(true);
    }
}
