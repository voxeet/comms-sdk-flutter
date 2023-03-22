package com.voxeet.sdk.push.center.subscription.event;

import androidx.annotation.NonNull;

public class ConferenceCreatedNotificationEvent {
    @NonNull
    public final String conferenceId;
    @NonNull
    public final String conferenceAlias;

    public ConferenceCreatedNotificationEvent(@NonNull String conferenceId, @NonNull String conferenceAlias) {
        this.conferenceId = conferenceId;
        this.conferenceAlias = conferenceAlias;
    }

    public String toString() {
        return "ConferenceCreatedNotificationEvent{conferenceId='" + this.conferenceId + '\'' + ", conferenceAlias='" + this.conferenceAlias + '\'' + '}';
    }
}
