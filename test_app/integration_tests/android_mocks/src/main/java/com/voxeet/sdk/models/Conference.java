package com.voxeet.sdk.models;

import androidx.annotation.NonNull;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.models.v1.ConferenceParticipantStatus;
import com.voxeet.sdk.models.v1.RecordingStatus;
import com.voxeet.sdk.services.SessionService;
import com.voxeet.sdk.services.conference.information.ConferenceStatus;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Conference {
    private List<Participant> participants = new ArrayList<>();
    private ConferenceStatus state = ConferenceStatus.ENDED;
    @NonNull
    private String id;

    @androidx.annotation.Nullable
    private String alias;

    @androidx.annotation.Nullable
    private RecordingInformation recordingInformation;
    private boolean isNew = false;


    public List<Participant> getParticipants() {
        return participants;
    }

    public ConferenceStatus getState() {
        return state;
    }

    public Conference setState(ConferenceStatus status) {
        state = status;
        return this;
    }

    @Nullable
    public Participant findParticipantById(@Nullable String participantId) {
        if (null == participantId) return null;
        for (Participant participant : participants) {
            if (participantId.equals(participant.getId())) return participant;
        }
        SessionService sessionService = VoxeetSDK.session();

        String localParticipantId = sessionService.getParticipantId();
        if (null != localParticipantId && localParticipantId.equals(participantId)) {
            return sessionService.getParticipant();
        }
        return null;
    }

    public String getId() {
        return id;
    }

    @androidx.annotation.Nullable
    public String getAlias() {
        return alias;
    }

    public boolean isNew() {
        return isNew;
    }

    public Conference setIsNew(boolean isNew) {
        this.isNew = isNew;
        return this;
    }

    public void setRecordingInformation(@androidx.annotation.Nullable RecordingInformation recordingInformation) {
        this.recordingInformation = recordingInformation;
    }

    public Conference setConferenceAlias(String alias) {
        this.alias = alias;
        return this;
    }

    public Conference setConferenceId(@NonNull String id) {
        this.id = id;
        return this;
    }

    @androidx.annotation.Nullable
    public RecordingInformation getRecordingInformation() {
        return recordingInformation;
    }

    public Conference addParticipant(Participant participant) {
        participants.add(participant);
        if (participant.getStatus() == ConferenceParticipantStatus.ON_AIR) {
            setState(ConferenceStatus.JOINED);
        }
        return this;
    }

    public static class RecordingInformation {

        private Date startRecordTimestamp;
        private RecordingStatus recordingStatus;
        private String recordingParticipant;

        public void setStartRecordTimestamp(Date startRecordTimestamp) {
            this.startRecordTimestamp = startRecordTimestamp;
        }

        public Date getStartRecordTimestamp() {
            return startRecordTimestamp;
        }

        public void setRecordingStatus(RecordingStatus recordingStatus) {
            this.recordingStatus = recordingStatus;
        }

        public RecordingStatus getRecordingStatus() {
            return recordingStatus;
        }

        public void setRecordingParticipant(String recordingParticipant) {
            this.recordingParticipant = recordingParticipant;
        }

        public String getRecordingParticipant() {
            return recordingParticipant;
        }
    }
}
