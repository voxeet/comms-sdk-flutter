package com.voxeet.sdk.services;

import android.app.Activity;
import android.content.Intent;

import com.voxeet.promise.Promise;

import org.jetbrains.annotations.NotNull;

public class ScreenShareService {
    public void sendRequestStartScreenShare() {

    }

    @NotNull
    public Promise<Boolean> stopScreenShare() {
        return Promise.resolve(true);
    }

    public void consumeRightsToScreenShare() {
    }

    public boolean onActivityResult(int requestCode, int resultCode, @NotNull Intent data) {
                return false;
    }

    public void sendUserPermissionRequest(@NotNull Activity it) {}
}
