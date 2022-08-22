package io.dolby.comms.sdk.flutter.extension

import io.flutter.plugin.common.MethodCall

fun <T> MethodCall.argumentOrThrow(key: String): T = argument(key) ?: throw KeyNotFoundException(key)

class KeyNotFoundException(key: String) : Exception("Key not found: $key")
