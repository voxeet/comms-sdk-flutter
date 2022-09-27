package com.voxeet.sdk.services.builders;

import com.voxeet.sdk.json.internal.ParamsHolder;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public class ConferenceCreateOptions {
    private String alias;
    private ParamsHolder paramsHolder;

    public String getAlias() {
        return alias;
    }

    public static class Builder {
        private final ConferenceCreateOptions options = new ConferenceCreateOptions();
        @NotNull
        public Builder setConferenceAlias(@Nullable String alias) {
            options.alias = alias;
            return this;
        }

        @NotNull
        public Builder setParamsHolder(@NotNull ParamsHolder paramsHolder) {
            options.paramsHolder = paramsHolder;
            return this;
        }

        @NotNull
        public ConferenceCreateOptions build() {
            return options;
        }
    }
}
