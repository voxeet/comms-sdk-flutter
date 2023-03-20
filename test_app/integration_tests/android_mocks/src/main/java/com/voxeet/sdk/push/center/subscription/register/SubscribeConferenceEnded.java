package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;

public class SubscribeConferenceEnded extends BaseSubscriptionWithAlias {
    public SubscribeConferenceEnded(@NonNull String conferenceAlias) {
        super(conferenceAlias, Subscription.Ended, true);
    }

    public String toString() {
        return "SubscribeConferenceCreated{conferenceAlias='" + this.conferenceAlias + '\'' + ", type='" + this.type + '\'' + '}';
    }
}
