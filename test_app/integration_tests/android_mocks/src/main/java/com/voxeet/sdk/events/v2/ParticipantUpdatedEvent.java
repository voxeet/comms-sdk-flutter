package com.voxeet.sdk.events.v2;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;

public class ParticipantUpdatedEvent {

    /**
     * The conference participant.
     */
    @NonNull
    public Participant participant;

    /**
     * The underlying Conference instance
     */
    @Nullable
    public Conference conference;

    public ParticipantUpdatedEvent(@NonNull Conference conference,
                                   @NonNull Participant participant) {
        this.participant = participant;
        this.conference = conference;
    }
}
