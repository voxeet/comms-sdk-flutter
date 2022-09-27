package com.voxeet.sdk.json;

public class ParticipantInfo {

    private String name;
    private String externalId;
    private String avatarUrl;

    public ParticipantInfo() {
        this.name = "";

        this.externalId = "";

        this.avatarUrl = "";
    }

    public ParticipantInfo(String name, String externalId, String avatarUrl) {

        this.name = name;
        this.externalId = externalId;
        this.avatarUrl = avatarUrl;
    }

    public String getExternalId() {
        return externalId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
}
