package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;
import com.voxeet.sdk.push.center.subscription.register.BaseSubscription;

public class BaseSubscriptionWithAlias extends BaseSubscription {
    @NonNull
    public String conferenceAlias;

    BaseSubscriptionWithAlias(@NonNull String conferenceAlias, @NonNull Subscription subscription, boolean network) {
        super(subscription, network);
        this.conferenceAlias = conferenceAlias;
    }
}
