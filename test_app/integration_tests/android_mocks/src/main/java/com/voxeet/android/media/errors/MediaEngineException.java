package com.voxeet.android.media.errors;

import androidx.annotation.NonNull;

public class MediaEngineException extends Exception {

    public MediaEngineException(@NonNull String message) {
        super(message);
    }
}
