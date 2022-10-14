package com.voxeet.android.media.spatialisation;

public class SpatialEnvironment {
    public SpatialScale scale;
    public SpatialPosition forward;
    public SpatialPosition up;
    public SpatialPosition right;

    public SpatialEnvironment(
            SpatialScale scale,
            SpatialPosition forward,
            SpatialPosition up,
            SpatialPosition right
    ) {
        this.scale = scale;
        this.forward = forward;
        this.up = up;
        this.right = right;
    }
}
