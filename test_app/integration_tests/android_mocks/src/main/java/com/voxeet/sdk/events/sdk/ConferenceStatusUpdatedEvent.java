package com.voxeet.sdk.events.sdk;

import androidx.annotation.NonNull;

import com.voxeet.sdk.services.conference.information.ConferenceStatus;

public class ConferenceStatusUpdatedEvent {
    @NonNull
    public ConferenceStatus state = ConferenceStatus.UNINITIALIZED;
}
