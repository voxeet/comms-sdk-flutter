package com.voxeet.sdk.services

import com.voxeet.VoxeetSDK

fun ConferenceService.clearConferences() {
    VoxeetSDK.conference().clearConferencesInformation()
}
