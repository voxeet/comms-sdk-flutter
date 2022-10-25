package com.voxeet.android.media.capture.audio.noise;

import androidx.annotation.NonNull;

public interface MappableNoiseReduction {
    @NonNull
    NoiseReduction transform();
}
