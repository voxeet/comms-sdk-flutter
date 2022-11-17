package com.voxeet.sdk.models.v1;

public class FilePresentationConverted {

    public String name;

    public long size;

    public String fileId;

    public int nbImageConverted;

    public FilePresentationConverted() {

    }

    public FilePresentationConverted(String name, String fileId, long size, int nbImageConverted) {
        this();

        this.name = name;
        this.size = size;
        this.fileId = fileId;
        this.nbImageConverted = nbImageConverted;
    }
}
