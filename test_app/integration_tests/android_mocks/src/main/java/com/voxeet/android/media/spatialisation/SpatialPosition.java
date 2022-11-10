package com.voxeet.android.media.spatialisation;

public class SpatialPosition {
    /**
     * The x-coordinate of a new audio location.
     */
    public final double x;
    /**
     * The y-coordinate of a new audio location.
     */
    public final double y;
    /**
     * The z-coordinate of a new audio location.
     */
    public final double z;

    public SpatialPosition(double x,
                           double y,
                           double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
