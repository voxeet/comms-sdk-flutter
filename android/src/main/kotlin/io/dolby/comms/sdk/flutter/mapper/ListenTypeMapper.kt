package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.ListenType
import java.security.InvalidParameterException

object ListenTypeMapper {
    fun fromValue(listenType: String): ListenType {
        return when (listenType) {
            REGULAR -> ListenType.REGULAR
            MIXED -> ListenType.MIXED
            else -> throw InvalidParameterException("Invalid value for listen type")
        }
    }


    private const val REGULAR = "REGULAR"
    private const val MIXED = "MIXED"
}