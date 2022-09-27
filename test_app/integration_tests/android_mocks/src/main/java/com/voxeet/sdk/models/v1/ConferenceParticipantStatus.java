package com.voxeet.sdk.models.v1;

import androidx.annotation.Nullable;

public enum ConferenceParticipantStatus {
    IN_PROGRESS(0),
    /**
     * A participant successfully connected to a conference. In the next release, this status will be replaced with a new status.
     */
    ON_AIR(1),
    LATER(2),
    /**
     * An invited participant declined the conference invitation.
     */
    DECLINE(3),
    /**
     * A participant left the conference.
     */
    LEFT(4),
    MISSED(5),
    /**
     * A participant is invited to a conference and waits for an invitation.
     */
    RESERVED(6),
    /**
     * A participant received the conference invitation and is connecting to a conference.
     */
    CONNECTING(7),
    /**
     * A participant did not enable audio, video, or screen-share and, therefore, is not connected to any stream.
     */
    INACTIVE(8),
    /**
     * A participant did not enable audio, video, or screen-share and, therefore, is not connected to any stream.
     */
    WARNING(9),
    /**
     * A participant experiences a peer connection problem, which may result in the `Error` or `Connected` status.
     */
    ERROR(10),
    UNKNOWN(11),
    /**
     * A participant was kicked from the conference.
     */
    KICKED(12);

    private final int value;

    ConferenceParticipantStatus(int value) {
        this.value = value;
    }

    /**
     * possibly invalid string to transform into a proper enum value
     *
     * @return the value.
     */
    public int value() {
        return value;
    }

    /**
     * Represents ordinal numbers of the enum from any possible integer. It returns the proper corresponding enum value.
     *
     * @param value Any number, preferrably a valid ordinal.
     * @return an enum representation. The default value is IN_PROGRESS.
     */
    public static ConferenceParticipantStatus fromId(int value) {
        switch (value) {
            case 1:
                return ON_AIR;
            case 2:
                return LATER;
            case 3:
                return DECLINE;
            case 4:
                return LEFT;
            case 5:
                return MISSED;
            case 6:
                return RESERVED;
            case 7:
                return CONNECTING;
            case 8:
                return INACTIVE;
            case 9:
                return WARNING;
            case 10:
                return ERROR;
            case 11:
                return UNKNOWN;
            case 12:
                return KICKED;
            default:
                return IN_PROGRESS;
        }
    }

    /**
     * Transform a possible integer value representing the enum ordinal to a possible english representation of the status. To be used for testing purposes.
     *
     * @param value the value with defaulting to "Pending invite"
     * @return the English representation of the ordinal
     */
    public static String toString(int value) {
        switch (value) {
            case 1:
                return "On Air";
            case 2:
                return "Later";
            case 3:
                return "Declined";
            case 4:
                return "Left";
            case 5:
                return "Missed";
            case 6:
                return "Reserved";
            case 7:
                return "Connecting";
            case 8:
                return "Inactive";
            case 11:
                return "";
            case 12:
                return "Kicked";
            default:
                return "Pending invite";
        }
    }

    /**
     * Transforms strings.
     *
     * @param status The possibly invalid string that can be transformed into a proper enum value.
     * @return an enum string representation. The default value is always IN_PROGRESS.
     */
    public static ConferenceParticipantStatus fromString(@Nullable String status) {
        if (null == status) return ConferenceParticipantStatus.ERROR;
        switch (status) {
            case "ON_AIR":
                return ON_AIR;
            case "LATER":
                return LATER;
            case "DECLINE":
                return DECLINE;
            case "LEFT":
                return LEFT;
            case "MISSED":
                return MISSED;
            case "RESERVED":
                return RESERVED;
            case "CONNECTING":
                return CONNECTING;
            case "INACTIVE":
                return INACTIVE;
            case "WARNING":
                return WARNING;
            case "ERROR":
                return ERROR;
            case "UNKNWON":
                return UNKNOWN;
            case "KICKED":
                return KICKED;
            default:
                return IN_PROGRESS;
        }
    }
}
