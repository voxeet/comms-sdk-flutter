package com.voxeet.sdk.models.v1;

public enum RecordingStatus {
    NOT_RECORDING(1),
    RECORDING(2);

    private int value;

    private RecordingStatus(int value) {
        this.value = value;
    }

    public int value() {
        return this.value;
    }

    public static RecordingStatus valueOf(int value) {
        switch (value) {
            case 1:
                return NOT_RECORDING;
            case 2:
                return RECORDING;
            default:
                return NOT_RECORDING;
        }
    }
}
