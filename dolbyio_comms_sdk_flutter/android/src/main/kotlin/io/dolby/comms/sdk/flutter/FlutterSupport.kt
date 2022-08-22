package io.dolby.comms.sdk.flutter

object FlutterSupport {
    fun isSupportedType(obj: Any?): Boolean {
        return obj?.let { v ->
            v is Boolean || v is Int || v is Long || v is Double || v is String
                || v.javaClass.isArray || obj is List<*> || obj is Map<*, *>

        } ?: true
    }
}
