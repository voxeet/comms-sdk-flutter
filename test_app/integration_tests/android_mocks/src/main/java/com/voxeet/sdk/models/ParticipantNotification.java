package com.voxeet.sdk.models;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.sdk.json.ParticipantInfo;
import com.voxeet.sdk.models.v1.ConferenceParticipantStatus;

public class ParticipantNotification {

    @Nullable
    private String id;

    @Nullable
    private ParticipantInfo participantInfo;

    @NonNull
    private ConferenceParticipantStatus status;


    private ParticipantNotification() {}

    public ParticipantNotification(@Nullable String id, @Nullable ParticipantInfo participantInfo,
                                   @NonNull ConferenceParticipantStatus status) {
        this();
        this.id = id;
        this.participantInfo = participantInfo;
        this.status = status;
    }

    @NonNull
    public ConferenceParticipantStatus getStatus() {
        return status;
    }

    @Nullable
    public String getId() {
        return id;
    }

    @Nullable
    public ParticipantInfo getInfo() {
        return participantInfo;
    }
}
