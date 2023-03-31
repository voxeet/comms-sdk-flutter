package com.voxeet.sdk.push.center.subscription.event;

import androidx.annotation.NonNull;

import com.voxeet.sdk.models.ParticipantNotification;
import java.util.List;

public class ActiveParticipantsEvent {
    public final List<ParticipantNotification> participants;
    public final String conferenceId;
    public final String conferenceAlias;
    public final int participantCount;

    public ActiveParticipantsEvent(@NonNull String conferenceId, @NonNull String conferenceAlias, @NonNull List<ParticipantNotification> participants, int participantCount) {
        this.conferenceId = conferenceId;
        this.conferenceAlias = conferenceAlias;
        this.participants = participants;
        this.participantCount = participantCount;
    }
}
