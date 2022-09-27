package com.voxeet.sdk.services;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.services.presentation.PresentationState;
import com.voxeet.sdk.services.presentation.video.VideoPresentation;

import org.jetbrains.annotations.NotNull;

import java.util.List;

/**
 * VideoPresentationService mock
 */
public class VideoPresentationService {
    protected List<VideoPresentation> presentations;
    @Nullable
    public VideoPresentation getCurrentPresentation() {
        for (VideoPresentation information : presentations) {
            if (!PresentationState.STOP.equals(information.state)) return information.clone();
        }
        return null;
    }

    @NonNull
    public Promise<VideoPresentation> start(@NonNull final String url) {
        return new Promise<VideoPresentation>(solver -> {
            VideoPresentation result = null;
            for (VideoPresentation presentation : presentations) {
                if (presentation.url.equals(url)) {
                    result = presentation;
                    break;
                }
            }
            solver.resolve(result);
        });
    }

    @NonNull
    public Promise<VideoPresentation> stop() {
        return Promise.resolve(null);
    }

    @NonNull
    public Promise<VideoPresentation> play() {
        return Promise.resolve(null);
    }

    @NonNull
    public Promise<VideoPresentation> pause(final long timestamp) {
        return Promise.resolve(null);
    }

    @NonNull
    public Promise<VideoPresentation> seek(final long timestamp) {
        return Promise.resolve(null);
    }
}
