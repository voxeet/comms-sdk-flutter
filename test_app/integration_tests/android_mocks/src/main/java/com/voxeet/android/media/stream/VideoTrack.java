package com.voxeet.android.media.stream;

public class VideoTrack {

    private String id;

    public VideoTrack(long nativeVideoTrack) {
        nativeInitVideoTrack(nativeVideoTrack);
    }

    public String id() {
        return this.id;
    }

    public void id(String id) {
        this.id = id;
    }

    private native void nativeInitVideoTrack(long nativeVideoTrack);
}
