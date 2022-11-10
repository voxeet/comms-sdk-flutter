package com.voxeet.sdk.services;

import androidx.annotation.NonNull;

import com.voxeet.VoxeetSDK;
import com.voxeet.promise.Promise;

import org.jetbrains.annotations.NotNull;

public class CommandService {

    public String sendArgs = "";

    @NonNull
    public Promise<Boolean> send(@NonNull String conferenceId, @NonNull final String message) {
        sendArgs = message;
        return Promise.resolve(true);
    }
}
