package com.voxeet.android.media.utils;

public enum ComfortNoiseLevel {
    /**
     * The default comfort noise level that is based on the device database. The database includes the proper comfort noise levels, individual for all devices.
     */
    DEFAULT(0),
    /**
     * The low comfort noise level.
     */
    LOW(1),
    /**
     * The medium comfort noise level.
     */
    MEDIUM(2),
    /**
     * The disabled comfort noise.
     */
    OFF(3);

    private final int value;

    ComfortNoiseLevel(int value) {
        this.value = value;
    }

    public int value() {
        return value;
    }
}
