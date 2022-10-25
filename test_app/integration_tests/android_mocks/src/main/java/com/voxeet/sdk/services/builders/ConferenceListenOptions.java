package com.voxeet.sdk.services.builders;

import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.VideoForwardingStrategy;

import org.jetbrains.annotations.NotNull;

public class ConferenceListenOptions {
    public final Conference conference;
    public String conferenceAccessToken;
    public int maxVideoForwarding;
    public boolean spatialAudio;

    private ConferenceListenOptions(Conference conference) {
        this.conference = conference;
    }

    public static class Builder {
        private final ConferenceListenOptions options;

        public Builder(@NotNull Conference conference) {
            options = new ConferenceListenOptions(conference);
        }

        public void setConferenceAccessToken(@NotNull String token) {
            options.conferenceAccessToken = token;
        }

        public void setMaxVideoForwarding(int maxForwarding) {
            options.maxVideoForwarding = maxForwarding;
        }

        public void setVideoForwardingStrategy(@NotNull VideoForwardingStrategy videoForwardingStrategy) {

        }

        @NotNull
        public Builder setSpatialAudio(boolean spatialAudio) {
            options.spatialAudio = spatialAudio;
            return this;
        }

        public ConferenceListenOptions build() {
            return options;
        }
    }
}
