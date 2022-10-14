package io.dolby.comms.sdk.flutter.dolbyio_comms_sdk_flutter_example

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.voxeet.sdk.services.ScreenShareService
import io.dolby.comms.sdk.flutter.MockAssertionClasses
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class MainActivity : FlutterActivity() {
    private val handler: Handler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        EventBus.getDefault().register(this)
    }

    override fun onPause() {
        super.onPause()
        EventBus.getDefault().unregister(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        if (BuildConfig.USE_MOCKS) {
            MockAssertionClasses.init(flutterEngine)
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        if (BuildConfig.USE_MOCKS) {
            MockAssertionClasses.clear()
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun forceOnActivityResult(action: ScreenShareService.SimulateOnActivityResult) {
        handler.postDelayed({
            val requestCode = 1
            val resultCode = 1
            val data = Intent()
            onActivityResult(requestCode, resultCode, data)
        }, 100)
    }
}
