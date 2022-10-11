package com.voxeet.sdk.services.builders;

import com.voxeet.sdk.media.constraints.Constraints;
import com.voxeet.sdk.models.Conference;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public class ConferenceJoinOptions {
    public Conference conference;
    public String conferenceId;
    public String conferenceAccessToken;
    public int maxForwarding;
    public Constraints constraints;
    public Object normal;
    public boolean spatialAudio;

    @androidx.annotation.Nullable
    public String getConferenceId() {
        return conferenceId;
    }

    public static class Builder {
        private final ConferenceJoinOptions options = new ConferenceJoinOptions();
        public Builder(@Nullable Conference conference) {
            options.conference = conference;
            options.conferenceId = conference != null ? conference.getId() : null;
        }

        public Builder setConferenceAccessToken(@NotNull String token) {
            options.conferenceAccessToken = token;
            return this;
        }

        public Builder setMaxVideoForwarding(int maxForwarding) {
            options.maxForwarding = maxForwarding;
            return this;
        }

        @NotNull
        public Builder setConstraints(@NotNull Constraints constraints) {
            options.constraints = constraints;
            return this;
        }

        @NotNull
        public Builder setConferenceParticipantType(@NotNull Object normal) {
            options.normal = normal;
            return this;
        }

        @NotNull
        public Builder setSpatialAudio(boolean spatialAudio) {
            options.spatialAudio = spatialAudio;
            return this;
        }

        public ConferenceJoinOptions build() {
            return options;
        }
    }
}
