package com.voxeet.sdk.services;

import android.os.Build;

import androidx.annotation.NonNull;

import com.voxeet.VoxeetSDK;
import com.voxeet.promise.Promise;
import com.voxeet.sdk.json.ParticipantInvited;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;
import com.voxeet.sdk.push.center.subscription.register.BaseSubscription;

import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class NotificationService {

    public static class InviteArgs {
        @Nullable
        private Conference conference;
        @Nullable
        private List<ParticipantInvited> participantsInvited;

        public void setInviteArgs(Conference conference, List<ParticipantInvited> participantsInvited) {
            this.conference = conference;
            this.participantsInvited = participantsInvited;
        }

        @androidx.annotation.Nullable
        public Conference getConference() {
            return conference;
        }

        @androidx.annotation.Nullable
        public List<ParticipantInvited> getParticipantsInvited() {
            return participantsInvited;
        }
    }

    private InviteArgs inviteArgs = new InviteArgs();
    private final Set<BaseSubscription> subscriptions = new HashSet<>();
    public InviteArgs getInviteArgs() {
        return inviteArgs;
    }

    public boolean inviteHasRun = false;
    @NonNull
    public Promise<List<Participant>> inviteWithPermissions(@NonNull final Conference conference, @NonNull final List<ParticipantInvited> participantsInvited) {
        inviteHasRun = true;
        inviteArgs.setInviteArgs(conference, participantsInvited);
        return VoxeetSDK.conference().inviteWithPermissions(conference.getId(), participantsInvited);
    }

    @Nullable
    public Conference declineArgs;

    public boolean declineHasRun = false;

    @NonNull
    public Promise<Boolean> decline(@NonNull final Conference conference) {
        String conferenceId = conference.getId();
        declineHasRun = true;
        declineArgs = conference;
        return Promise.resolve(true);
    }

    public Promise<Boolean> subscribe(List<BaseSubscription> subscriptions) {
        this.subscriptions.addAll(subscriptions);
        return Promise.resolve(true);
    }

    public Promise<Boolean> unsubscribe(List<BaseSubscription> subscriptions) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            subscriptions.forEach(this.subscriptions::remove);
        } else {
            for (BaseSubscription subscription : subscriptions) {
                this.subscriptions.remove(subscription);
            }
        }
        return Promise.resolve(true);
    }
}
