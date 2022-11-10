package com.voxeet.sdk.push.center.subscription.event;

import androidx.annotation.NonNull;

import com.voxeet.sdk.push.center.invitation.InvitationBundle;

public class InvitationReceivedNotificationEvent {
    /**
     * The invitation bundle
     */
    @NonNull
    public InvitationBundle invitation;

    public InvitationReceivedNotificationEvent() {

    }

    public InvitationReceivedNotificationEvent(@NonNull InvitationBundle invitation) {
        this.invitation = invitation;
    }
}
