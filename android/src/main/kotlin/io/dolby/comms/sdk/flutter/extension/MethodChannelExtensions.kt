package io.dolby.comms.sdk.flutter.extension

import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.error(throwable: Throwable) = error("EXCEPTION", throwable.message, null)
