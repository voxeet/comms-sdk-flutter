package com.voxeet.sdk.services;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.VoxeetSDK;
import com.voxeet.android.media.errors.SpatialArgumentException;
import com.voxeet.android.media.errors.SpatialAudioException;
import com.voxeet.android.media.spatialisation.SpatialDirection;
import com.voxeet.android.media.spatialisation.SpatialPosition;
import com.voxeet.android.media.spatialisation.SpatialScale;
import com.voxeet.promise.Promise;
import com.voxeet.sdk.json.ParticipantInfo;
import com.voxeet.sdk.json.ParticipantInvited;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;
import com.voxeet.sdk.models.ParticipantPermissions;
import com.voxeet.sdk.models.v1.ConferenceParticipantStatus;
import com.voxeet.sdk.services.builders.ConferenceCreateOptions;
import com.voxeet.sdk.services.builders.ConferenceJoinOptions;
import com.voxeet.sdk.services.builders.VideoForwardingOptions;
import com.voxeet.sdk.services.conference.AudioProcessing;
import com.voxeet.sdk.services.conference.information.ConferenceStatus;
import com.voxeet.sdk.utils.Opt;

import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class ConferenceService {

    public static Conference setMockConference(int type) {
        switch (type) {
            case 1:

        }
        return null;
    }

    @Nullable
    private Conference currentConference = null;

    private String mConferenceId = null;
    private boolean localUserLeft = false;

    public ConferenceCreateOptions createArgs;

    @NotNull
    public Promise<Conference> create(@NotNull ConferenceCreateOptions conferenceCreateOption) {
        createArgs = conferenceCreateOption;
        return new Promise<>(solver -> {
            currentConference = fromConferenceOptions(conferenceCreateOption);
            mConferenceId = currentConference.getId();
            currentConference.setState(ConferenceStatus.CREATED);
            solver.resolve(currentConference);
        });
    }

    @Nullable
    public Conference getConference() {
        return currentConference;
    }

    @Nullable
    public String getConferenceId() {
        return mConferenceId;
    }

    @NonNull
    public Conference getConference(@NonNull String conferenceId) {
        if (currentConference != null && conferenceId.equals(currentConference.getId())) {
            return currentConference;
        }
        return null;
    }

    @NotNull
    public Promise<Conference> fetchConference(@NotNull String conferenceId) {
        return new Promise<>(solver -> {
           solver.resolve(fetchInternal(conferenceId));
        });
    }

    @NotNull
    public Promise<Conference> join(@NonNull ConferenceJoinOptions options)  {
        return new Promise<>(solver -> {
            String id = Opt.of(options).then(ConferenceJoinOptions::getConferenceId).or("");
            if (id.equals("") || currentConference == null) {
                solver.reject(new NullPointerException("Conference is null or id is empty"));
            } else {
                joinInternal(options);
                solver.resolve(currentConference);
            }
        });
    }

    public Promise<Boolean> leave() {
        return new Promise(solver -> {
            Participant p = VoxeetSDK.session().getParticipant();
            boolean result = false;
            if (currentConference != null && p != null) {
                Participant participant = currentConference.findParticipantById(p.getId());
                result = participant != null && participant.getStatus() == ConferenceParticipantStatus.ON_AIR;
                p.setStatus(ConferenceParticipantStatus.LEFT);

            }
            solver.resolve(result);
        });
    }

    public double audioLevel(@Nullable Participant participant) {
        if (currentConference != null && participant != null) {
            Participant p = currentConference.findParticipantById(participant.getId());
            return p != null ? 1 : 0;
        }
        return 0;
    }

    @Nullable
    public Participant findParticipantById(@NotNull String participantId) {
        return Opt.of(getConference()).then(c -> c.findParticipantById(participantId)).orNull();
    }

    public List<Participant> getParticipants() {
        return currentConference != null ? currentConference.getParticipants() : new ArrayList<>();
    }

    public boolean isMuted() {
        return false;
    }

    public boolean mute(@NonNull Participant participant, boolean mute) {
        return true;
    }

    public boolean mute(boolean mute) {
        return true;
    }

    @NotNull
    public Promise<Boolean> kick(@NotNull Participant p) {
        return Promise.resolve(true);
    }

    @NotNull
    public boolean muteOutput(boolean mute) {
        return true;
    }

    @NotNull
    public Promise<Boolean> startAudio(@NotNull Participant p) {
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> startAudio() {
        return startAudio(VoxeetSDK.session().getParticipant());
    }

    @NotNull
    public Promise<Boolean> stopAudio(@NotNull Participant it) {
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> stopAudio() {
        return stopAudio(VoxeetSDK.session().getParticipant());
    }

    @NotNull
    public Promise<Boolean> startVideo(@NotNull Participant p) {
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> startVideo() {
        return startVideo(VoxeetSDK.session().getParticipant());
    }

    @NotNull
    public Promise<Boolean> stopVideo(@NotNull Participant it) {
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> stopVideo() {
        return stopVideo(VoxeetSDK.session().getParticipant());
    }

    public void setSpatialPosition(@NonNull Participant participant, @NonNull SpatialPosition position) throws SpatialAudioException {
        throw new SpatialAudioException("not implemented");
    }

    public void setSpatialPosition(@NonNull SpatialPosition position) throws SpatialAudioException {
        setSpatialPosition(VoxeetSDK.session().getParticipant(), position);
    }

    public void setSpatialEnvironment(@NonNull SpatialScale scale,
                                      @NonNull SpatialPosition forward,
                                      @NonNull SpatialPosition up,
                                      @NonNull SpatialPosition right) throws SpatialArgumentException, SpatialAudioException {
        // will throw SpatialAudioException in non dvc or listener

    }

    public void setSpatialDirection(@NonNull SpatialDirection direction) throws SpatialAudioException {

    }

    @NotNull
    public Map<String, JSONArray> localStats() {
        return new HashMap<>();
    }

    @NotNull
    @Deprecated
    public Promise<Boolean> videoForwarding(int max, @Nullable List<Participant> participants) {
        return Promise.resolve(true);
    }

    @NonNull
    public Promise<Boolean> videoForwarding(@NonNull VideoForwardingOptions options) {
        return Promise.resolve(true);
    }

    @Nullable
    public Integer getMaxVideoForwarding() {
        return 0;
    }

    @NotNull
    public boolean setAudioProcessing(@NonNull AudioProcessing audioProcessing) {
        return false;
    }

    @NonNull
    public Promise<Conference> replay(@NonNull final Conference conference, final long offset) {
        return Promise.resolve(conference);
    }

    @NonNull
    public Promise<Boolean> updatePermissions(@NonNull List<ParticipantPermissions> participantPermissions) {
        return new Promise<>(solver -> {
            solver.resolve(true);
        });
    }

    public boolean isSpeaking(@NotNull Participant p) {
        return true;
    }

    public Promise<List<Participant>> inviteWithPermissions(final String conferenceId, final List<ParticipantInvited> participantsInvited) {
        return new Promise<>(solver -> {
            //Warning = getConferenceParticipants is returning a new non retained if not in a conference
            List<Participant> participants = getParticipants();

            try {
                if (null != participantsInvited) {
                    for (ParticipantInvited invited_info : participantsInvited) {
                        ParticipantInfo info = invited_info.getParticipant();
                        if (null != info && info.getExternalId() != null) {
                            String participantInfoId = info.getExternalId();
                            for (Participant participant : participants) {
                                String arrayId = participant.getInfo() != null ? participant.getInfo().getExternalId() : null;
                                if (null != arrayId && arrayId.equalsIgnoreCase(participantInfoId)) {
                                    participant.updateIfNeeded(info.getName(), info.getAvatarUrl());
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            solver.resolve(participants);
        });
    }

    private Conference fetchInternal(String conferenceId) {
        return new Conference().setConferenceId(conferenceId);
    }

    private void joinInternal(ConferenceJoinOptions options) {
        Participant localP = VoxeetSDK.session().getParticipant();
        if (currentConference != null && localP != null) {
            currentConference.addParticipant(localP);
            localP.setStatus(ConferenceParticipantStatus.ON_AIR);
            currentConference.setState(ConferenceStatus.JOINED);
        }
    }

    private Conference fromConferenceOptions(ConferenceCreateOptions createOption) {
        UUID newConfId = UUID.randomUUID();
        Conference conference = new Conference();
        conference.setConferenceId(newConfId.toString());
        conference.setConferenceAlias(createOption.getAlias());
        conference.setState(ConferenceStatus.CREATING);
        return conference;
    }
}
