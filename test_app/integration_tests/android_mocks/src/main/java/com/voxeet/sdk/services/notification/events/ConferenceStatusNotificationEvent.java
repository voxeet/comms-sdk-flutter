package com.voxeet.sdk.services.notification.events;

import androidx.annotation.Nullable;
import com.voxeet.sdk.models.ParticipantNotification;
import java.util.ArrayList;
import java.util.List;

public class ConferenceStatusNotificationEvent {
    @Nullable
    public final String conferenceId;
    @Nullable
    public final String conferenceAlias;
    @Nullable
    public final boolean isLive;
    @Nullable
    public final long startTimestamp;
    public final List<ParticipantNotification> participants;

    private ConferenceStatusNotificationEvent() {
        this.conferenceId = "";
        this.conferenceAlias = "";
        this.isLive = false;
        this.startTimestamp = 0L;
        this.participants = new ArrayList();
    }

    public ConferenceStatusNotificationEvent(@Nullable String conferenceId, @Nullable String conferenceAlias, boolean isLive, long startTimestamp, List<ParticipantNotification> participants) {
        this.conferenceId = conferenceId;
        this.conferenceAlias = conferenceAlias;
        this.isLive = isLive;
        this.startTimestamp = startTimestamp;
        this.participants = participants;
    }
}
