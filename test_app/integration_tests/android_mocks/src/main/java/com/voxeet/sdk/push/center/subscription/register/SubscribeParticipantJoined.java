package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;

public class SubscribeParticipantJoined extends BaseSubscriptionWithAlias {
    public SubscribeParticipantJoined(@NonNull String conferenceAlias) {
        super(conferenceAlias, Subscription.ParticipantJoined, true);
    }

    public String toString() {
        return "SubscribeParticipantJoined{conferenceAlias='" + this.conferenceAlias + '\'' + ", type='" + this.type + '\'' + '}';
    }
}
