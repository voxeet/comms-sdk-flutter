package com.voxeet.sdk.json;

import java.util.Set;

public class ParticipantInvited {
    private ParticipantInfo participant;
    private Set<ConferencePermission> permissions;

    public ParticipantInvited(ParticipantInfo participant) {
        this.participant = participant;
    }

    /**
     * The participant's information.
     */
    public ParticipantInfo getParticipant() {
        return participant;
    }

    public void setParticipant(ParticipantInfo participant) {
        this.participant = participant;
    }

    /**
     * The possible permissions a participant may have in a conference.
     */
    public Set<ConferencePermission> getPermissions() {
        return permissions;
    }

    public void setPermissions(Set<ConferencePermission> permissions) {
        this.permissions = permissions;
    }
}
