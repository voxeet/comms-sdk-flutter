package com.voxeet.sdk.services;

import com.voxeet.sdk.services.video.LocalVideo;
import com.voxeet.sdk.services.video.RemoteVideo;

public class VideoService {
    public LocalVideo local = new LocalVideo();
    public final RemoteVideo remote = new RemoteVideo();
}
