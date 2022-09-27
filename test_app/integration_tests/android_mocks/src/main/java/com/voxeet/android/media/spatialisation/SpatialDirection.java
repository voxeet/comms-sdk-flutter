package com.voxeet.android.media.spatialisation;

public class SpatialDirection {
    /**
     * The Euler rotation about the x-axis, in degrees.
     */
    public final double x;
    /**
     * The Euler rotation about the y-axis, in degrees.
     */
    public final double y;
    /**
     * The Euler rotation about the z-axis, in degrees.
     */
    public final double z;

    public SpatialDirection(double x,
                            double y,
                            double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
