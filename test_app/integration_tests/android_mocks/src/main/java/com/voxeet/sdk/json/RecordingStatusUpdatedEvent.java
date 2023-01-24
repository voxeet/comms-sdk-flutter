package com.voxeet.sdk.json;

public class RecordingStatusUpdatedEvent {
    public String conferenceId;

    /**
     * The ID of the participant who has recorded the conference.
     */
    public String participantId;

    /**
     * The representation of raw recording status.
     */
    public String recordingStatus;

    /**
     * The corresponding timestamp.
     */
    public long timeStamp;
}
