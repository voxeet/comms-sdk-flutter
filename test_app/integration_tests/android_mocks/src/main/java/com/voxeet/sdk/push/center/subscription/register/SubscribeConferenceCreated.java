package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;
import com.voxeet.sdk.push.center.subscription.register.BaseSubscriptionWithAlias;

public class SubscribeConferenceCreated extends BaseSubscriptionWithAlias {
    public SubscribeConferenceCreated(@NonNull String conferenceAlias) {
        super(conferenceAlias, Subscription.Created, true);
    }

    public String toString() {
        return "SubscribeConferenceCreated{conferenceAlias='" + this.conferenceAlias + '\'' + ", type='" + this.type + '\'' + '}';
    }
}
