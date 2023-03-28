package com.voxeet.sdk.push.center.subscription.event;

import androidx.annotation.NonNull;
import com.voxeet.sdk.models.ParticipantNotification;

public class ParticipantLeftNotificationEvent {
    @NonNull
    public final String conferenceId;
    @NonNull
    public final String conferenceAlias;
    @NonNull
    public final ParticipantNotification participant;

    public ParticipantLeftNotificationEvent(@NonNull String conferenceId, @NonNull String conferenceAlias, @NonNull ParticipantNotification participant) {
        this.conferenceId = conferenceId;
        this.conferenceAlias = conferenceAlias;
        this.participant = participant;
    }

    public String toString() {
        return "ParticipantLeftNotificationEvent{conferenceId='" + this.conferenceId + '\'' + ", conferenceAlias='" + this.conferenceAlias + '\'' + ", participant='" + this.participant + '\'' + '}';
    }
}
