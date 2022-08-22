package io.dolby.comms.sdk.flutter.module

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

interface NativeModule : MethodChannel.MethodCallHandler {

    fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding)
    fun onDetached()
}
