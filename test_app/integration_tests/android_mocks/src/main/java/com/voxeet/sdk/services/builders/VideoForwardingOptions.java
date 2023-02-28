package com.voxeet.sdk.services.builders;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.sdk.models.VideoForwardingStrategy;

import org.jetbrains.annotations.NotNull;

import java.util.List;

public class VideoForwardingOptions {
    @Nullable
    public Integer max = null;
    @Nullable
    public VideoForwardingStrategy strategy = null;
    @Nullable
    public List<String> participants = null;

    public static class Builder {
        private VideoForwardingOptions options = new VideoForwardingOptions();

        @NotNull
        public Builder setMaxVideoForwarding(int max) {
            options.max = max;
            return this;
        }

        @NotNull
        public Builder setParticipants(@NotNull List<String> participants) {
            options.participants = participants;
            return this;
        }

        public Builder setVideoForwardingStrategy(@NonNull VideoForwardingStrategy strategy) {
            options.strategy = strategy;
            return this;
        }

        public VideoForwardingOptions build() {
            return options;
        }
    }
}
