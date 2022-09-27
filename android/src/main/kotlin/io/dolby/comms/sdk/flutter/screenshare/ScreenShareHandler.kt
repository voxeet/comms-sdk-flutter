package io.dolby.comms.sdk.flutter.screenshare

import android.app.Activity
import android.content.Intent
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.voxeet.VoxeetSDK
import com.voxeet.promise.Promise
import com.voxeet.sdk.services.screenshare.RequestScreenSharePermissionEvent
import com.voxeet.sdk.services.screenshare.ScreenCapturerService
import io.flutter.plugin.common.PluginRegistry
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class ScreenShareHandler : DefaultLifecycleObserver, PluginRegistry.ActivityResultListener {

    var activity: Activity? = null

    override fun onResume(owner: LifecycleOwner) {
        super.onResume(owner)
        activity?.let {
            ScreenCapturerService.register(it)
            VoxeetSDK.instance().register(this)
            VoxeetSDK.screenShare().consumeRightsToScreenShare()
            VoxeetSDK.localStats().startAutoFetch()
        }
    }

    override fun onPause(owner: LifecycleOwner) {
        activity?.let {
            ScreenCapturerService.unregisterActivity()
            VoxeetSDK.instance().unregister(this)
            VoxeetSDK.localStats().stopAutoFetch()
        }
        super.onPause(owner)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        val granted = data != null && VoxeetSDK.screenShare().onActivityResult(requestCode, resultCode, data)
        listener?.invoke(granted)
        return granted
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: RequestScreenSharePermissionEvent) {
        activity?.let { VoxeetSDK.screenShare().sendUserPermissionRequest(it) }
    }

    companion object {
        private var listener: ((Boolean) -> Unit)? = null

        fun permissionResult() = Promise<Boolean> { solver ->
            listener = {
                solver.resolve(it)
                listener = null
            }
        }
    }
}
