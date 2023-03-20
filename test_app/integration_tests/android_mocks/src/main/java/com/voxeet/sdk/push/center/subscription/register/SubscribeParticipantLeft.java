package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;

public class SubscribeParticipantLeft extends BaseSubscriptionWithAlias {
    public SubscribeParticipantLeft(@NonNull String conferenceAlias) {
        super(conferenceAlias, Subscription.ParticipantJoined, true);
    }

    public String toString() {
        return "SubscribeParticipantLeft{conferenceAlias='" + this.conferenceAlias + '\'' + ", type='" + this.type + '\'' + '}';
    }
}
