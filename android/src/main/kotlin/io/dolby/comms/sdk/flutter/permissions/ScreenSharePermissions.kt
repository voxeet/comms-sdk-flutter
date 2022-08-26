package io.dolby.comms.sdk.flutter.permissions

import android.app.Activity
import android.content.Intent
import com.voxeet.VoxeetSDK
import com.voxeet.promise.Promise

object ScreenSharePermissions {

    private var listener: ShareScreenPermissionListener? = null

    fun request(activity: Activity) {
        VoxeetSDK.screenShare().sendUserPermissionRequest(activity)
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        val granted = data != null && VoxeetSDK.screenShare().onActivityResult(requestCode, resultCode, data)
        listener?.onPermissionResult(granted)
    }

    fun permissionResult() = Promise<Boolean> { solver ->
        ShareScreenPermissionListener { granted ->
            solver.resolve(granted)
            listener = null
        }.also { listener = it }
    }

    private fun interface ShareScreenPermissionListener {
        fun onPermissionResult(granted: Boolean)
    }
}
