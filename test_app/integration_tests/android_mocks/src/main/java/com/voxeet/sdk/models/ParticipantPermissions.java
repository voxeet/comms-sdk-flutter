package com.voxeet.sdk.models;

import androidx.annotation.NonNull;

import com.voxeet.sdk.json.ConferencePermission;

import java.util.Set;

public class ParticipantPermissions {
    /**
     * The participant.
     */
    @NonNull
    public Participant participant;

    /**
     * The set of participant's [conference permissions](doc:android-client-sdk-model-conferencepermission).
     */
    @NonNull
    public Set<ConferencePermission> permissions;
}
