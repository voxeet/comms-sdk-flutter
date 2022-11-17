package com.voxeet.sdk.authent.token;

import androidx.annotation.NonNull;

public interface RefreshTokenCallback {
    /**
     * A callback that returns a promise when the conference access token needs to be refreshed.
     *
     * @param is_expired A boolean value that informs whether the previous conference access token has expired. This parameter indicates the current state of the access token and should not be used for determining whether the access token should refresh.
     * @param callback A callback that returns a promise when the conference access token needs to be refreshed.
     */
    void onRequired(boolean is_expired, @NonNull TokenCallback callback);
}
