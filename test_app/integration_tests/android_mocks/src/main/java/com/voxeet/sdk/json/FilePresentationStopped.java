package com.voxeet.sdk.json;

public class FilePresentationStopped {
    /**
     * The conference ID.
     */
    public String conferenceId;

    /**
     * The file owner's ID.
     */
    public String userId;

    /**
     * The file ID.
     */
    public String fileId;

    public FilePresentationStopped() {}

    public FilePresentationStopped(String conferenceId,
                                   String userId,
                                   String fileId) {
        this();
        this.conferenceId = conferenceId;
        this.userId = userId;
        this.fileId = fileId;
    }
}
