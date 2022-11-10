package com.voxeet.sdk.services;

import android.app.Activity;
import android.content.Intent;

import com.voxeet.promise.Promise;

import org.greenrobot.eventbus.EventBus;
import org.jetbrains.annotations.NotNull;

import io.dolby.SimulateOnActivityResult;

public class ScreenShareService {
    public boolean broadcast = false;

    public void sendRequestStartScreenShare() {
        EventBus.getDefault().post(new SimulateOnActivityResult());
    }

    @NotNull
    public Promise<Boolean> stopScreenShare() {
        return Promise.resolve(true);
    }

    public void consumeRightsToScreenShare() {
    }

    public boolean onActivityResult(int requestCode, int resultCode, @NotNull Intent data) {
        broadcast = true;
        return true;
    }

    public void sendUserPermissionRequest(@NotNull Activity it) {}
}
