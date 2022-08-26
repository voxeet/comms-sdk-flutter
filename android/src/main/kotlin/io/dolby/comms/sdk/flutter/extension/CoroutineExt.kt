package io.dolby.comms.sdk.flutter.extension

import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.launch

fun CoroutineScope.launch(
    onError: (Throwable) -> Unit,
    onSuccess: suspend CoroutineScope.() -> Unit
) = launch(
    CoroutineExceptionHandler { _, throwable -> onError(throwable) },
    CoroutineStart.DEFAULT,
    onSuccess
)
