package com.voxeet.sdk.services;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.json.ParticipantInfo;
import com.voxeet.sdk.models.Participant;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.UUID;

public class SessionService {
    @Nullable
    public Participant participant = null;

    public boolean closeHasRun = false;

    private int counter = 0;
    private boolean openHasRun = false;

    public Promise<Boolean> open(@NotNull ParticipantInfo participantInfo) {
        openHasRun = true;
        participant = new Participant(getNextId(), participantInfo);
        return Promise.resolve(participantInfo != null);
    }

    public Promise<Boolean> close() {
        closeHasRun = true;
        participant = null;
        openHasRun = false;
        return Promise.resolve(true);
    }

    public boolean isOpen() {
        return openHasRun;
    }

    public String getParticipantId() {
        return isOpen() ? participant.getId() : null;
    }

    private String getNextId() {
        UUID newParticipantId = UUID.randomUUID();
        return newParticipantId.toString();
    }
}
