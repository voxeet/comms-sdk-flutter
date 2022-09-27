package com.voxeet.sdk.services;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.json.ParticipantInfo;
import com.voxeet.sdk.models.Participant;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.UUID;

public class SessionService {
    @Nullable
    private Participant localParticipant = null;

    private int counter = 0;

    public Promise<Boolean> open(@NotNull ParticipantInfo participantInfo) {
        localParticipant = new Participant(getNextId(), participantInfo);
        return Promise.resolve(participantInfo != null);
    }

    public Promise<Boolean> close() {
        localParticipant = null;
        return Promise.resolve(true);
    }

    public boolean isOpen() {
        return localParticipant != null;
    }

    public Participant getParticipant() {
        return localParticipant;
    }

    public String getParticipantId() {
        return isOpen() ? localParticipant.getId() : null;
    }

    private String getNextId() {
        UUID newParticipantId = UUID.randomUUID();
        return newParticipantId.toString();
    }
}
