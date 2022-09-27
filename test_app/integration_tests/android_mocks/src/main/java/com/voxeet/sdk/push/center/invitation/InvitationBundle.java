package com.voxeet.sdk.push.center.invitation;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.sdk.models.ParticipantNotification;

public class InvitationBundle {
    @Nullable
    public String conferenceId;

    @NonNull
    public ParticipantNotification inviter;
}
