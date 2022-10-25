package com.voxeet.sdk.services;

import com.voxeet.promise.Promise;
import com.voxeet.sdk.services.audio.LocalAudio;
import com.voxeet.sdk.services.audio.RemoteAudio;

public class AudioService {

    public final LocalAudio local = new LocalAudio();

    public RemoteAudio remote = new RemoteAudio();

    public boolean isSpeakerOn() {
        return false;
    }

    public void setSpeakerMode(boolean isSpeakerOn) {}
}
