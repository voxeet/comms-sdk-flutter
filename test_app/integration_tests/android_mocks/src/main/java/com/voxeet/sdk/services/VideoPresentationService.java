package com.voxeet.sdk.services;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.services.presentation.PresentationState;
import com.voxeet.sdk.services.presentation.video.VideoPresentation;

import java.util.ArrayList;
import java.util.List;

/**
 * VideoPresentationService mock
 */
public class VideoPresentationService {
    protected List<VideoPresentation> presentations = new ArrayList<>();
    public PresentationState currentState = PresentationState.STOP;
    public VideoPresentation current = new VideoPresentation("key", "url");

    @Nullable
    public VideoPresentation getCurrentPresentation() {
        current.state = currentState;
        presentations.add(current);
        for (VideoPresentation information : presentations) {
            if (!PresentationState.STOP.equals(information.state))
                return information.clone();
        }
        return null;
    }

    public boolean startHasRun = false;

    @org.jetbrains.annotations.Nullable
    public String startArgs;

    @NonNull
    public Promise<VideoPresentation> start(@NonNull final String url) {
        startHasRun = true;
        startArgs = url;
        currentState = PresentationState.PLAY;
        current.url = url;
        presentations.add(current);
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

    public boolean stopHasRun = false;
    @NonNull
    public Promise<VideoPresentation> stop() {
        stopHasRun = true;
        currentState = PresentationState.STOP;
        return Promise.resolve(null);
    }

    public boolean playHasRun = false;
    @NonNull
    public Promise<VideoPresentation> play() {
        playHasRun = true;
        currentState = PresentationState.PLAY;
        return Promise.resolve(null);
    }

    public boolean pauseHasRun = false;
    public long pauseArgs;
    @NonNull
    public Promise<VideoPresentation> pause(final long timestamp) {
        pauseHasRun = true;
        pauseArgs = timestamp;
        currentState = PresentationState.PAUSED;
        return Promise.resolve(null);
    }

    public boolean seekHasRun = false;
    public long seekArgs;
    @NonNull
    public Promise<VideoPresentation> seek(final long timestamp) {
        seekHasRun = true;
        seekArgs = timestamp;
        return Promise.resolve(null);
    }
}
