package io.dolby.comms.sdk.flutter.extension

import com.voxeet.promise.Promise
import com.voxeet.promise.PromiseInOut
import com.voxeet.promise.solve.ThenValue
import com.voxeet.promise.solve.ThenVoid
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

//typealias ExtPromise<T> = com.voxeet.promise.Promise<T>

suspend fun <T> Promise<T>.await(): T = suspendCoroutine { continuation ->
    this.then(ThenVoid { continuation.resume(it) }).error { continuation.resumeWithException(it) }
}

suspend fun <T, R> PromiseInOut<T, R>.await(): R = suspendCoroutine { continuation ->
    this.then(ThenValue { continuation.resume(it) }).error { continuation.resumeWithException(it) }
}

/**
 * Util method to simplify building promises chain mapping
 *
 * ```
 * Promises.promise(Obj)
 *  .thenValue { obj -> Obj2 }
 * ```
 *
 * @param thenValue [ThenValue] mapped value provider
 */
fun <T, R> Promise<T>.thenValue(thenValue: ThenValue<T, R>): PromiseInOut<T, R> = then(thenValue)

/**
 * Throws [IllegalArgumentException] if emitted value is null
 *
 * ```
 * promiseThatCanEmitNull
 *  .rejectIfNull()
 * ```
 *
 * @param nullErrorMessage error message provider in case of null value
 */
fun <T> Promise<T?>.rejectIfNull(nullErrorMessage: () -> String = { "Required value is null" }): PromiseInOut<T?, T> =
    thenValue { requireNotNull(it, nullErrorMessage) }

/**
 * Throws [IllegalArgumentException] if emitted value is false
 *
 * ```
 * promiseThatEmitBoolean
 *  .rejectIfFalse()
 * ```
 *
 * @param lazyMessage error message provider in case of false value
 */
fun Promise<Boolean>.rejectIfFalse(
    lazyMessage: () -> String = { "Returned promise value is false" }
): PromiseInOut<Boolean, Any?> =
    thenValue {
        require(it, lazyMessage)
        null
    }