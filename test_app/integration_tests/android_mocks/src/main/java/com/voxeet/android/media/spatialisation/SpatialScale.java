package com.voxeet.android.media.spatialisation;

public class SpatialScale {
    /**
     * The x component of the SpatialScale vector.
     */
    public final double x;
    /**
     * The y component of the SpatialScale vector.
     */
    public final double y;
    /**
     * The z component of the SpatialScale vector.
     */
    public final double z;

    public SpatialScale(double x,
                        double y,
                        double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
