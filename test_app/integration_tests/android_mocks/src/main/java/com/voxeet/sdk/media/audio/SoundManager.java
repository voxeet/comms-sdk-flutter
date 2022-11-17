package com.voxeet.sdk.media.audio;

import org.jetbrains.annotations.NotNull;

public class SoundManager {
    public boolean switchDeviceSpeakerHasRun = false;
    private boolean speakerOn = false;

    @NotNull
    public SoundManager setSpeakerMode(@NotNull boolean isSpeakerOn) {
        speakerOn = isSpeakerOn;
        switchDeviceSpeakerHasRun = true;
        return this;
    }

    public boolean isSpeakerOn() {
        return speakerOn;
    }
}
