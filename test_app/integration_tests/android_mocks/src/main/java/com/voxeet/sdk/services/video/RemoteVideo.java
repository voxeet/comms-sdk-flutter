package com.voxeet.sdk.services.video;

import androidx.annotation.NonNull;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.models.Participant;

public class RemoteVideo {
    public Participant startArgs = null;
    public Participant stopArgs = null;

    public Promise<Boolean> start(@NonNull Participant participant) {
        startArgs = participant;
        return Promise.resolve(true);
    }

    public Promise<Boolean> stop(@NonNull Participant participant) {
        stopArgs = participant;
        return Promise.resolve(true);
    }
}
