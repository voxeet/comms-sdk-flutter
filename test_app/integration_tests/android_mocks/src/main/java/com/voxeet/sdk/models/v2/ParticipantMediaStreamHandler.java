package com.voxeet.sdk.models.v2;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.android.media.MediaStream;
import com.voxeet.android.media.stream.MediaStreamType;
import com.voxeet.sdk.models.Participant;

public class ParticipantMediaStreamHandler {
    private Participant participant;

    public ParticipantMediaStreamHandler(Participant participant) {
        this.participant = participant;
    }

    @Nullable
    public MediaStream getFirst(@NonNull MediaStreamType type) {
        for (MediaStream stream : participant.streams()) {
            if (type.equals(stream.getType())) return stream;
        }
        return null;
    }
}
