package com.voxeet.sdk.events.sdk;

import androidx.annotation.NonNull;

import com.voxeet.sdk.json.ConferencePermission;

import java.util.HashSet;
import java.util.Set;

public class PermissionsUpdatedEvent {
    @NonNull
    public Set<ConferencePermission> permissions;

    public PermissionsUpdatedEvent(@NonNull Set<ConferencePermission> permissions) {
        this.permissions = new HashSet<>();
        this.permissions.addAll(permissions);
    }
}
