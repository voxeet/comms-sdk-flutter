package com.voxeet.sdk.services.conference.information;

public enum ConferenceStatus {
    UNINITIALIZED(true),
    CREATING(true),
    CREATED(true),
    JOINING(true),
    JOINED(true),
    LEAVING(false),
    LEFT(false),
    ERROR(false),
    DESTROYED(false),
    ENDED(false);

    private final boolean mValid;

    ConferenceStatus(boolean valid) {
        mValid = valid;
    }

    /**
     * Checks if the current state is valid. It corresponds to the attended conference.
     *
     * @return a boolean indicating if a conference is valid.
     */
    public boolean isValid() {
        return mValid;
    }
}