package io.dolby.comms.sdk.flutter.mapper

import io.dolby.comms.sdk.flutter.FlutterSupport

class MapSupportTypeMapper(private val map: Map<Any, Any?>) : Mapper() {

    override fun convertToMap(): Map<String, Any?> {
        val result: Map<String, Any?> = map.mapKeys {
            it.key as String
        }
        return result.mapValues {
            if (FlutterSupport.isSupportedType(it.value)) {
                it.value
            } else {
                of(it)?.convertToMap()
            }

        }
    }
}