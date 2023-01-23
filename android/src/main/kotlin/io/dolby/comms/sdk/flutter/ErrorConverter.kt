package io.dolby.comms.sdk.flutter

import java.lang.reflect.InvocationTargetException

class ErrorConverter {

    fun message(t: Throwable): String {
        return if (t is InvocationTargetException) {
            t.targetException.message ?: ""
        } else {
            t.message ?: ""
        }
    }

    fun toMap(t: Throwable): Map<String, Any?> {
        if (t is InvocationTargetException) {
            return mapOf(
                "type" to t.javaClass.simpleName,
                "message" to t.message,
                "stackTrace" to t.stackTrace.map {
                    mapOf(
                        "fileName" to it.fileName,
                        "className" to it.className,
                        "methodName" to it.methodName,
                        "lineNumber" to it.lineNumber,
                        "cause" to toMap(t.targetException)
                    )
                }
            )
        } else {
            return mapOf(
                "type" to t.javaClass.simpleName,
                "message" to t.message,
                "stackTrace" to t.stackTrace.map {
                    mapOf(
                        "fileName" to it.fileName,
                        "className" to it.className,
                        "methodName" to it.methodName,
                        "lineNumber" to it.lineNumber,
                    )
                }
            )
        }

    }


    fun errorCode(): String {
         return "EXCEPTION"
    }
}