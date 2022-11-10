package com.voxeet.sdk.events.v2;

import androidx.annotation.NonNull;

import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;

public class ParticipantAddedEvent {

    /**
     * The conference participant.
     */
    @NonNull
    public Participant participant;

    /**
     * The underlying Conference instance
     */
    @NonNull
    public Conference conference;

    public ParticipantAddedEvent(@NonNull Conference conference,
                                 @NonNull Participant participant) {
        this.participant = participant;
        this.conference = conference;
    }
}
