package com.voxeet.sdk.models;

import androidx.annotation.NonNull;

import com.voxeet.android.media.MediaStream;
import com.voxeet.sdk.json.ParticipantInfo;
import com.voxeet.sdk.models.v1.ConferenceParticipantStatus;
import com.voxeet.sdk.models.v2.ParticipantMediaStreamHandler;
import com.voxeet.sdk.models.v2.ParticipantType;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class Participant {
    @Nullable
    private ParticipantInfo participantInfo;
    private String id;
    @NonNull
    private ConferenceParticipantStatus status;
    private final List<MediaStream> streams;
    private final ParticipantMediaStreamHandler streamsHandler;
    @NonNull
    private ParticipantType participantType = ParticipantType.USER;

    private Participant() {
        status = ConferenceParticipantStatus.UNKNOWN;
        streams = new CopyOnWriteArrayList<>();
        streamsHandler = new ParticipantMediaStreamHandler(this);
    }

    public Participant(@androidx.annotation.Nullable String id,
                @androidx.annotation.Nullable ParticipantInfo participantInfo) {
        this(id, participantInfo, ConferenceParticipantStatus.UNKNOWN);
    }

    public Participant(@androidx.annotation.Nullable String id,
                       @androidx.annotation.Nullable ParticipantInfo participantInfo,
                       @NonNull ConferenceParticipantStatus status) {
        this();
        this.id = id;
        this.participantInfo = participantInfo;
        this.status = status;
    }

    public ParticipantInfo getInfo() {
        return participantInfo;
    }

    public String getId() {
        return id;
    }

    @NonNull
    public ConferenceParticipantStatus getStatus() {
        return status;
    }

    public void setStatus(@NonNull ConferenceParticipantStatus status) {
        this.status = status;
    }

    @NonNull
    public ParticipantType participantType() {
        if (null == participantType) return ParticipantType.USER;
        return participantType;
    }

    public void updateIfNeeded(@androidx.annotation.Nullable String name, @androidx.annotation.Nullable String avatarUrl) {
        if (null == participantInfo) {
            participantInfo = new ParticipantInfo();
        }

        if (null != name && (null == participantInfo.getName() || !name.equals(participantInfo.getName())))
            participantInfo.setName(name);
        if (null != avatarUrl && (null == participantInfo.getAvatarUrl() || avatarUrl.equals(participantInfo.getAvatarUrl())))
            participantInfo.setAvatarUrl(avatarUrl);
    }

    @NotNull
    public List<MediaStream> streams() {
        return streams;
    }

    @NonNull
    public ParticipantMediaStreamHandler streamsHandler() {
        return streamsHandler;
    }
}
