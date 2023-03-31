package com.voxeet.sdk.push.center.subscription.register;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.subscription.Subscription;

public class BaseSubscription {
    public final String type;
    private boolean network = false;

    BaseSubscription(@NonNull Subscription subscription, boolean network) {
        this.network = network;
        this.type = subscription.type;
    }

    public final boolean isNetworkCall() {
        return this.network;
    }
}
