package com.voxeet.sdk.services.audio;

import androidx.annotation.NonNull;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.models.Participant;

public class RemoteAudio {

    public Promise<Boolean> start(@NonNull Participant participant) {
        return Promise.resolve(true);
    }

    public Promise<Boolean> stop(@NonNull Participant participant) {
        return Promise.resolve(true);
    }
}
