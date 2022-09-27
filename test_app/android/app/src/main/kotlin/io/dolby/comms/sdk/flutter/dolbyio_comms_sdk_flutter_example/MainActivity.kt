package io.dolby.comms.sdk.flutter.dolbyio_comms_sdk_flutter_example

import android.os.Bundle
import io.dolby.comms.sdk.flutter.MockAssertionClasses
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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
}
