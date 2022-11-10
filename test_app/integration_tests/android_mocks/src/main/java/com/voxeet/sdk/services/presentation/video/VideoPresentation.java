package com.voxeet.sdk.services.presentation.video;

import androidx.annotation.NonNull;

import com.voxeet.sdk.services.presentation.PresentationState;

public class VideoPresentation {

    /**
     * Represent the unique key for the presentation. This must be treated as a Primary key to differentiate presentations.
     */
    public final String key;

    /**
     * The URL informing about the location of the presented video.
     */
    public String url;

    /**
     * The current state of the video presentation.
     */
    public PresentationState state;

    /**
     * The latest timestamp informing about the current video position.
     */
    public long lastSeekTimestamp;

    private VideoPresentation() {
        key = "";
        url = "";
    }

    public VideoPresentation(@NonNull String key, @NonNull String url) {
        this.key = key;
        this.url = url;
    }

    public VideoPresentation clone() {
        VideoPresentation information = new VideoPresentation(key, url);
        information.state = state;
        return information;
    }
}
