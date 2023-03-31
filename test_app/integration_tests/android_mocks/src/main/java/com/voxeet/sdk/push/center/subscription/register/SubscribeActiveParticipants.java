package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;

public class SubscribeActiveParticipants extends BaseSubscriptionWithAlias {
    public SubscribeActiveParticipants(@NonNull String conferenceAlias) {
        super(conferenceAlias, Subscription.ActiveParticipants, true);
    }

    public String toString() {
        return "SubscribeActiveParticipants{conferenceAlias='" + this.conferenceAlias + '\'' + ", type='" + this.type + '\'' + '}';
    }
}
