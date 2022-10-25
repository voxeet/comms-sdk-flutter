package com.voxeet.android.media.capture.audio.noise;

import androidx.annotation.NonNull;

public enum StandardNoiseReduction implements MappableNoiseReduction {
    HIGH,
    LOW;

    @NonNull
    @Override
    public NoiseReduction transform() {
        switch (this) {
            case HIGH:
                return NoiseReduction.HIGH;
            case LOW:
            default:
                return NoiseReduction.LOW;
        }
    }
}
