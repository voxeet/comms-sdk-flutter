package com.voxeet.sdk.services.presentation;

public enum PresentationState {
    STOP(0),
    PLAY(1),
    PAUSED(2),
    STARTED(3),
    SEEK(4),
    CONVERTED(5);

    private final int value;

    PresentationState(int value) {
        this.value = value;
    }

    public int value() {
        return value;
    }
}
