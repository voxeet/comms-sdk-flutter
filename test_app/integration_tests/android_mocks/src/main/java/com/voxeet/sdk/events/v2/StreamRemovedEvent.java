package com.voxeet.sdk.events.v2;

import androidx.annotation.NonNull;

import com.voxeet.android.media.MediaStream;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;

public class StreamRemovedEvent {
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

    /**
     * The media stream.
     */
    @NonNull
    public MediaStream mediaStream;

    public StreamRemovedEvent(@NonNull Conference conference,
                              @NonNull Participant participant,
                              @NonNull MediaStream mediaStream) {
        this.participant = participant;
        this.conference = conference;
        this.mediaStream = mediaStream;
    }
}
