package com.voxeet.sdk.json.internal;

import androidx.annotation.NonNull;

import com.voxeet.sdk.services.conference.spatialisation.SpatialAudioStyle;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Locale;

public class ParamsHolder {
    private HashMap<String, Object> paramsHolder;

    public ParamsHolder(@NotNull HashMap<String, Object> paramsHolder) {
        this.paramsHolder = paramsHolder;
    }

    public boolean isDolbyVoice() {
        return paramsHolder.containsKey("dolbyVoice") ? (boolean) paramsHolder.get("dolbyVoice") : false;
    }

    public boolean isLiveRecording() {
        return paramsHolder.containsKey("liveRecording") ? (boolean) paramsHolder.get("liveRecording") : false;
    }

    public String getRtcpMode() {
        return paramsHolder.containsKey("rtcpMode") ? paramsHolder.get("rtcpMode").toString() : null;
    }

    public Integer getTtl() {
        return paramsHolder.containsKey("ttl") ? (Integer) paramsHolder.get("ttl") : null;
    }

    public String getVideoCodec() {
        return paramsHolder.containsKey("videoCodec") ? paramsHolder.get("videoCodec").toString() : null;
    }

    public ParamsHolder setSpatialAudioStyle(@NonNull SpatialAudioStyle spatialAudioStyle) {
        paramsHolder.put("spatialAudioStyle", spatialAudioStyle.name().toLowerCase(Locale.ROOT));
        return this;
    }
}
