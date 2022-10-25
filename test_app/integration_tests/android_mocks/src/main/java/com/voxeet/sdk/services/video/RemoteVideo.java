package com.voxeet.sdk.services.video;

import androidx.annotation.NonNull;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.models.Participant;

public class RemoteVideo {

    public Promise<Boolean> start(@NonNull Participant participant) {
        return Promise.resolve(true);
    }

    public Promise<Boolean> stop(@NonNull Participant participant) {
        return Promise.resolve(true);
    }
}
