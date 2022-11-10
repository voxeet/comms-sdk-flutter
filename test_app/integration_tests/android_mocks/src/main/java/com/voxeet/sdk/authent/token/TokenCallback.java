package com.voxeet.sdk.authent.token;

import androidx.annotation.NonNull;

public interface TokenCallback {
    void ok(@NonNull String callable);

    void error(@NonNull Throwable error);
}
