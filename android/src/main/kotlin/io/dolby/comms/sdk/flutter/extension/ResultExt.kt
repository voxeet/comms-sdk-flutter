package io.dolby.comms.sdk.flutter.extension

import io.dolby.comms.sdk.flutter.ErrorConverter
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.onError(t: Throwable) {
    val converter = ErrorConverter()
    this.error(converter.errorCode(), converter.message(t), converter.toMap(t))
}