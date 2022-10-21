package io.dolby.comms.sdk.flutter.dolbyio_comms_sdk_flutter_example

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.dolby.SimulateOnActivityResult
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
        if (isMockSet()) {
            MockAssertionClasses.init(flutterEngine)
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        if (isMockSet()) {
            MockAssertionClasses.clear()
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun forceOnActivityResult(action: SimulateOnActivityResult) {
        handler.postDelayed({
            val requestCode = 1
            val resultCode = 1
            val data = Intent()
            onActivityResult(requestCode, resultCode, data)
        }, 100)
    }

    private fun isMockSet(): Boolean {
        try {
            val field = BuildConfig::class.java.getField("USE_MOCKS")
            return field.getBoolean(null)
        } catch (e: NoSuchFieldException) {
            return false
        }
    }
}
