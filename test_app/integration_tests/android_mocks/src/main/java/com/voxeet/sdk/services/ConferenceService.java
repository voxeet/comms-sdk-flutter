package com.voxeet.sdk.services;

import android.util.Pair;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.VoxeetSDK;
import com.voxeet.android.media.errors.SpatialArgumentException;
import com.voxeet.android.media.errors.SpatialAudioException;
import com.voxeet.android.media.spatialisation.SpatialDirection;
import com.voxeet.android.media.spatialisation.SpatialEnvironment;
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

    public Conference joinReturn = null;
    @Nullable
    public Conference current = new Conference().setConferenceId("conference_id").setConferenceAlias("conference_alias");

    public Conference fetchReturn = null;
    public String fetchArgs = null;
    public Conference createReturn = null;
    public ConferenceJoinOptions joinArgs = null;
    public Participant kickArgs = null;
    public boolean leaveHasRun = false;
    public boolean kickReturn = false;
    public Participant audioLevelArgs = null;
    public Float audioLevelReturn;
    public Integer maxVideoForwardingReturn;
    public Participant startAudioArgs;
    public Participant stopAudioArgs;
    public Participant startVideoArgs;
    public Participant stopVideoArgs;
    public Pair<Participant, SpatialPosition> spatialPositionArgs;
    public SpatialDirection spatialDirectionArgs;
    public boolean muteOutputArgs = false;
    public Pair<Participant, Boolean> muteArgs;
    public boolean isSpeakingReturn;
    public boolean isMutedReturn;
    public Participant speakingArgs;
    public Pair<List<Participant>, Integer> videoForwardingArgs;
    public AudioProcessing audioProcessingArgs;

    private String mConferenceId = null;
    private boolean localUserLeft = false;

    public ConferenceCreateOptions createArgs;
    public Pair<Conference, Long> replayArgs;
    public SpatialEnvironment spatialEnvironmentArgs;
    public List<ParticipantPermissions> updatePermissionsArgs;

    @NotNull
    public Promise<Conference> create(@NotNull ConferenceCreateOptions conferenceCreateOption) {
        createArgs = conferenceCreateOption;
        return new Promise<>(solver -> {
//            currentConference = fromConferenceOptions(conferenceCreateOption);
//            mConferenceId = currentConference.getId();
//            currentConference.setState(ConferenceStatus.CREATED);
//            solver.resolve(currentConference);
            solver.resolve(createReturn);
        });
    }

    @Nullable
    public Conference getConference() {
        return current;
    }

    @Nullable
    public String getConferenceId() {
        return getConference().getId();
    }

    @NonNull
    public Conference getConference(@NonNull String conferenceId) {
        if (current != null && conferenceId.equals(current.getId())) {
            return current;
        }
        if (fetchReturn != null && conferenceId.equals(fetchReturn.getId())) {
            return fetchReturn;
        }
        if (joinReturn != null && conferenceId.equals(joinReturn.getId())) {
            return joinReturn;
        }
        return new Conference()
                .setConferenceId(conferenceId)
                .setConferenceAlias("conference_alias")
                .setState(ConferenceStatus.CREATED);
    }

    @NotNull
    public Promise<Conference> fetchConference(@NotNull String conferenceId) {
        return new Promise<>(solver -> {
            fetchArgs = conferenceId;
            solver.resolve(fetchReturn);
        });
    }

    @NotNull
    public Promise<Conference> join(@NonNull ConferenceJoinOptions options) {
        return new Promise<>(solver -> {
            joinArgs = options;
            if (joinReturn != null) {
                joinReturn.setState(ConferenceStatus.JOINED);
            }
            solver.resolve(joinReturn);
        });
    }

    public Promise<Boolean> leave() {
        return new Promise(solver -> {
            leaveHasRun = true;
            Participant p = VoxeetSDK.session().participant;
            boolean result = false;
            if (current != null && p != null) {
                Participant participant = current.findParticipantById(p.getId());
                result = participant != null && participant.getStatus() == ConferenceParticipantStatus.ON_AIR;
                p.setStatus(ConferenceParticipantStatus.LEFT);

            }
            solver.resolve(result);
        });
    }

    public double audioLevel(@Nullable Participant participant) {
        audioLevelArgs = participant;
        return audioLevelReturn;
    }

    @Nullable
    public Participant findParticipantById(@NotNull String participantId) {
        return Opt.of(getConference()).then(c -> c.findParticipantById(participantId)).orNull();
    }

    public List<Participant> getParticipants() {
        return current != null ? current.getParticipants() : new ArrayList<>();
    }

    public boolean isMuted() {
        return isMutedReturn;
    }

    public boolean mute(@NonNull Participant participant, boolean mute) {
        muteArgs = new Pair<>(participant, mute);
        return true;
    }

    public boolean mute(boolean mute) {
        return mute(VoxeetSDK.session().participant, mute);
    }

    @NotNull
    public Promise<Boolean> kick(@NotNull Participant p) {
        kickArgs = p;
        kickReturn = current != null && current.findParticipantById(p.getId()) != null;
        return Promise.resolve(kickReturn);
    }

    @NotNull
    public boolean muteOutput(boolean mute) {
        muteOutputArgs = mute;
        return true;
    }

    @NotNull
    public Promise<Boolean> startAudio(@NotNull Participant p) {
        startAudioArgs = p;
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> startAudio() {
        return startAudio(VoxeetSDK.session().participant);
    }

    @NotNull
    public Promise<Boolean> stopAudio(@NotNull Participant p) {
        stopAudioArgs = p;
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> stopAudio() {
        return stopAudio(VoxeetSDK.session().participant);
    }

    @NotNull
    public Promise<Boolean> startVideo(@NotNull Participant p) {
        startVideoArgs = p;
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> startVideo() {
        return startVideo(VoxeetSDK.session().participant);
    }

    @NotNull
    public Promise<Boolean> stopVideo(@NotNull Participant p) {
        stopVideoArgs = p;
        return Promise.resolve(true);
    }

    @NotNull
    public Promise<Boolean> stopVideo() {
        return stopVideo(VoxeetSDK.session().participant);
    }

    public void setSpatialPosition(@NonNull Participant participant, @NonNull SpatialPosition position) throws SpatialAudioException {
        spatialPositionArgs = new Pair<>(participant, position);
    }

    public void setSpatialPosition(@NonNull SpatialPosition position) throws SpatialAudioException {
        setSpatialPosition(VoxeetSDK.session().participant, position);
    }

    public void setSpatialEnvironment(@NonNull SpatialScale scale,
                                      @NonNull SpatialPosition forward,
                                      @NonNull SpatialPosition up,
                                      @NonNull SpatialPosition right) throws SpatialArgumentException, SpatialAudioException {
        // will throw SpatialAudioException in non dvc or listener
        spatialEnvironmentArgs = new SpatialEnvironment(scale, forward, up, right);
    }

    public void setSpatialDirection(@NonNull SpatialDirection direction) throws SpatialAudioException {
        spatialDirectionArgs = direction;
    }

    @NotNull
    public Map<String, JSONArray> localStats() {
        return new HashMap<>();
    }

    @NotNull
    @Deprecated
    public Promise<Boolean> videoForwarding(int max, @Nullable List<Participant> participants) {
        videoForwardingArgs = new Pair<>(participants, max);
        return Promise.resolve(true);
    }

    @NonNull
    public Promise<Boolean> videoForwarding(@NonNull VideoForwardingOptions options) {
        return Promise.resolve(true);
    }

    @Nullable
    public Integer getMaxVideoForwarding() {
        return maxVideoForwardingReturn;
    }

    @NotNull
    public boolean setAudioProcessing(@NonNull AudioProcessing audioProcessing) {
        audioProcessingArgs = audioProcessing;
        return false;
    }

    @NonNull
    public Promise<Conference> replay(@NonNull final Conference conference, final long offset) {
        replayArgs = new Pair<>(conference, offset);
        return Promise.resolve(conference);
    }

    @NonNull
    public Promise<Boolean> updatePermissions(@NonNull List<ParticipantPermissions> participantPermissions) {
        updatePermissionsArgs = participantPermissions;
        return new Promise<>(solver -> {
            solver.resolve(true);
        });
    }

    public boolean isSpeaking(@NotNull Participant p) {
        speakingArgs = p;
        return isSpeakingReturn;
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

    private void joinInternal(ConferenceJoinOptions options) {
        Participant localP = VoxeetSDK.session().participant;
        if (current != null && localP != null) {
            current.addParticipant(localP);
            localP.setStatus(ConferenceParticipantStatus.ON_AIR);
            current.setState(ConferenceStatus.JOINED);
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

    void clearConferencesInformation() {}
}
