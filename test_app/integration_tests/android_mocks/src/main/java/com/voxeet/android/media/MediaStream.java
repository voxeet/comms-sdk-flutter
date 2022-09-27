package com.voxeet.android.media;

import androidx.annotation.NonNull;

import com.voxeet.android.media.stream.AudioTrack;
import com.voxeet.android.media.stream.MediaStreamType;
import com.voxeet.android.media.stream.VideoTrack;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;

public class MediaStream {
    /**
     * The peer id of the stream owner
     */
    private String peerId;

    /**
     * The underlying stream label
     */
    private String label;


    /**
     * A list of AudioTracks
     */
    @NonNull
    private List<AudioTrack> audioTrackList = new ArrayList<>();

    /**
     * A list of VideoTracks
     */
    @NonNull
    private List<VideoTrack> videoTrackList = new ArrayList<>();

    /**
     * MediaStream Type representation
     */
    private MediaStreamType type;

    /**
     * Retrieves the hard list of AudioTracks.
     *
     * @return the list of audio tracks
     */
    @NonNull
    public List<AudioTrack> audioTracks() {
        return this.audioTrackList;
    }

    /**
     * Retrieves the hard list of VideoTracks.
     *
     * @return the list of video tracks
     */
    @NonNull
    public List<VideoTrack> videoTracks() {
        return this.videoTrackList;
    }

    /**
     * Gets the peer identifier.
     *
     * @return a valid string
     */
    public String peerId() {
        return this.peerId;
    }

    /**
     * Gets the MediaStream label.
     *
     * @return the label written
     */
    public String label() {
        return this.label;
    }

    @NonNull
    public MediaStreamType getType() {
        return type;
    }
}
