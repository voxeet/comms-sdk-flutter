package com.voxeet.sdk.json;

import androidx.annotation.Nullable;

public enum ConferencePermission {
    /**
     * Allows a participant to invite participants to a conference.
     */
    INVITE,
    /**
     * Allows a participant to kick other participants from a conference
     */
    KICK,
    /**
     * Allows a participant to update other participants' permissions.
     */
    UPDATE_PERMISSIONS,
    /**
     * Allows a participant to join a conference.
     */
    JOIN,
    /**
     * Allows a participant to send an audio stream during a conference.
     */
    SEND_AUDIO,
    /**
     * Allows a participant to share a video during a conference.
     */
    SEND_VIDEO,
    /**
     * Allows a participant to share a screen during a conference.
     */
    SHARE_SCREEN,
    /**
     * Allows a participant to send a video stream during a conference.
     */
    SHARE_VIDEO,
    /**
     * Allows a participant to share a file during a conference.
     */
    SHARE_FILE,
    /**
     * Allows a participant to send a message to other participants during a conference. Message size is limited to 16KB.
     */
    SEND_MESSAGE,
    /**
     * Allows a participant to record a conference.
     */
    RECORD,
    /**
     * Allows a participant to stream a conference.
     */
    STREAM;

    public static @Nullable
    ConferencePermission fromString(String value) {
        try {
            return ConferencePermission.valueOf(value);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
