package com.voxeet.sdk.json;

public class VideoPresentationPaused {
    /**
     * The key of the current video.
     */
    public String key;

    /**
     * The conference ID.
     */
    public String conferenceId;

    /**
     * The ID of the participant who shares a video.
     */
    public String participantId;

    /**
     * The current timestamp of the shared video.
     */
    public long timestamp;
}
