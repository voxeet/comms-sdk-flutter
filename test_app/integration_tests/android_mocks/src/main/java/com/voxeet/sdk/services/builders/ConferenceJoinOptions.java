package com.voxeet.sdk.services.builders;

import com.voxeet.sdk.media.constraints.Constraints;
import com.voxeet.sdk.models.Conference;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public class ConferenceJoinOptions {
    private String conferenceId;

    @androidx.annotation.Nullable
    public String getConferenceId() {
        return conferenceId;
    }

    public static class Builder {
        private final ConferenceJoinOptions options = new ConferenceJoinOptions();
        public Builder(@Nullable Conference conference) {
            options.conferenceId = conference != null ? conference.getId() : null;
        }

        public Builder setConferenceAccessToken(@NotNull String token) {
            return this;
        }

        public Builder setMaxVideoForwarding(int maxForwarding) {
            return this;
        }

        @NotNull
        public Builder setConstraints(@NotNull Constraints constraints) {
            return this;
        }

        @NotNull
        public Builder setConferenceParticipantType(@NotNull Object normal) {
            return this;
        }

        @NotNull
        public Builder setSpatialAudio(boolean b) {
            return this;
        }

        public ConferenceJoinOptions build() {
            return options;
        }
    }
}
