package com.voxeet.sdk.push.center.subscription;

public enum Subscription {
    Created("Conference.Created"),
    Ended("Conference.Ended"),
    Invitation("Invitation"),
    ParticipantJoined("Participant.Joined"),
    ParticipantLeft("Participant.Left"),
    ActiveParticipants("Conference.ActiveParticipants");

    public final String type;

    private Subscription(String type) {
        this.type = type;
    }
}
