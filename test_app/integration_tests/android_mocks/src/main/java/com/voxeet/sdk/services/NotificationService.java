package com.voxeet.sdk.services;

import androidx.annotation.NonNull;

import com.voxeet.VoxeetSDK;
import com.voxeet.promise.Promise;
import com.voxeet.sdk.json.ParticipantInvited;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;

import java.util.List;

public class NotificationService {
    @NonNull
    public Promise<List<Participant>> inviteWithPermissions(@NonNull final Conference conference, @NonNull final List<ParticipantInvited> participantsInvited) {
        return VoxeetSDK.conference().inviteWithPermissions(conference.getId(), participantsInvited);
    }

    @NonNull
    public Promise<Boolean> decline(@NonNull final Conference conference) {
        String conferenceId = conference.getId();

        return Promise.resolve(true);
    }
}
