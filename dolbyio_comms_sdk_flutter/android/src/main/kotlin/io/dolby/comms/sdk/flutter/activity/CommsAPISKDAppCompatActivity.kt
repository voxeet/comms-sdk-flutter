package io.dolby.comms.sdk.flutter.activity

import android.content.Intent
import android.util.Log
import com.voxeet.VoxeetSDK
import com.voxeet.android.media.stream.MediaStreamType
import com.voxeet.sdk.events.sdk.ConferenceStatusUpdatedEvent
import com.voxeet.sdk.events.v2.ParticipantUpdatedEvent
import com.voxeet.sdk.events.v2.StreamAddedEvent
import com.voxeet.sdk.events.v2.StreamRemovedEvent
import com.voxeet.sdk.events.v2.StreamUpdatedEvent
import com.voxeet.sdk.events.v2.VideoStateEvent
import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.models.v1.ConferenceParticipantStatus
import com.voxeet.sdk.services.screenshare.RequestScreenSharePermissionEvent
import com.voxeet.sdk.services.screenshare.ScreenCapturerService
import com.voxeet.sdk.views.VideoView
import io.dolby.comms.sdk.flutter.permissions.ScreenSharePermissions
import io.flutter.embedding.android.FlutterActivity
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

open class CommsAPISKDAppCompatActivity : FlutterActivity() {

    override fun onResume() {
        super.onResume()
        ScreenCapturerService.register(this)
        VoxeetSDK.instance().register(this)
        VoxeetSDK.screenShare().consumeRightsToScreenShare()
    }

    override fun onPause() {
        //stop fetching stats if any pending
        if (!VoxeetSDK.conference().isLive) {
            VoxeetSDK.localStats().stopAutoFetch()
        }
        VoxeetSDK.instance().unregister(this)
        ScreenCapturerService.unregisterActivity()
        super.onPause()
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: RequestScreenSharePermissionEvent) {
        ScreenSharePermissions.request(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        ScreenSharePermissions.onActivityResult(requestCode, resultCode, data)
    }

}
