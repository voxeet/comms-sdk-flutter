package com.voxeet.android.media.stream;

public class AudioTrack {
    private String id;

    public AudioTrack(long nativeAudioTrack) {
        this.nativeInitAudioTrack(nativeAudioTrack);
    }

    public String id() {
        return this.id;
    }

    public void id(String id) {
        this.id = id;
    }

    private native void nativeInitAudioTrack(long nativeAudioTrack);
}
