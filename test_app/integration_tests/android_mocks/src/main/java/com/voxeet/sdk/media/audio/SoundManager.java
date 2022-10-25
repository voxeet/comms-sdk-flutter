package com.voxeet.sdk.media.audio;

import org.jetbrains.annotations.NotNull;

public class SoundManager {
    private boolean speakerOn = false;

    @NotNull
    public SoundManager setSpeakerMode(@NotNull boolean isSpeakerOn) {
        speakerOn = isSpeakerOn;
        return this;
    }

    public boolean isSpeakerOn() {
        return speakerOn;
    }
}
