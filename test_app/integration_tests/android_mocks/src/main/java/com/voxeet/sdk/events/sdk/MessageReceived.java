package com.voxeet.sdk.events.sdk;

public class MessageReceived {

    /**
     * The ID of the sender.
     */
    public String participantId;

    /**
     * The conference ID.
     */
    public String conferenceId;

    /**
     * The corresponding message.
     */
    public String message;

    public MessageReceived(String participantId, String conferenceId, String message) {
        this.participantId = participantId;
        this.conferenceId = conferenceId;
        this.message = message;
    }

}

