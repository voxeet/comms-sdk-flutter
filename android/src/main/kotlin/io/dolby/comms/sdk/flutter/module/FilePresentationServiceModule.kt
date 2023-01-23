package io.dolby.comms.sdk.flutter.module

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.provider.OpenableColumns
import android.util.Log
import com.voxeet.VoxeetSDK
import com.voxeet.sdk.models.v1.FilePresentationConverted
import io.dolby.comms.sdk.flutter.events.FilePresentationEventEmitter
import io.dolby.comms.sdk.flutter.extension.*
import io.dolby.comms.sdk.flutter.mapper.FileConvertedMapper
import io.dolby.comms.sdk.flutter.mapper.FilePresentationMapper
import io.dolby.comms.sdk.flutter.state.FilePresentationHolder
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancelChildren
import java.io.File
import java.io.FileOutputStream

class FilePresentationServiceModule(
    private val context: Context,
    private val scope: CoroutineScope,
    private val filePresentationEventEmitter: FilePresentationEventEmitter,
    private val filePresentationHolder: FilePresentationHolder
) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::convert.name -> convert(call, result)
            ::getCurrent.name -> getCurrent(result)
            ::getImage.name -> getImage(call, result)
            ::getThumbnail.name -> getThumbnail(call, result)
            ::setPage.name -> setPage(call, result)
            ::start.name -> start(call, result)
            ::stop.name -> stop(result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_file_presentation_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun convert(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            fileFromUri(call.argumentOrThrow("uri"))
                .let { file ->
                    VoxeetSDK
                        .filePresentation()
                        .convert(file)
                        .await()
                        .let { file to it }
                }
                .let { (file, filePresentation) ->
                    val ownerId = VoxeetSDK.session().participantId ?: throw IllegalStateException("No session open")
                    val fileConverted = FileConvertedMapper(
                        ownerId = ownerId,
                        fileName = file.name,
                        filePresentation = filePresentation
                    ).convertToMap()
                    filePresentationEventEmitter.onFileConverted(fileConverted)
                    result.success(fileConverted)
                }
        }
    )

    private fun getCurrent(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val conference = VoxeetSDK.conference().conference ?: throw IllegalStateException("Missing current conference")
            val noStartedPresentationError = lazyOf(Exception("No started file presentation for current conference"))
            val ownerId = filePresentationHolder.getOwnerId(conference.id) ?: throw noStartedPresentationError.value
            val noPresentationOwnerError = lazyOf(Exception("Unable to find file presentation owner by id =  $ownerId"))
            val presentation = filePresentationHolder.getPresentation(conference.id) ?: throw noStartedPresentationError.value
            val owner = conference.findParticipantById(ownerId) ?: throw noPresentationOwnerError.value

            FilePresentationMapper(owner, presentation)
                .convertToMap()
                .let { result.success(it) }
        }
    )

    private fun getImage(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            getCurrentFileId()
                .let { VoxeetSDK.filePresentation().image(it, call.argumentOrThrow("page")) }
                .let { result.success(it) }
        }
    )

    private fun getThumbnail(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            getCurrentFileId()
                .let { VoxeetSDK.filePresentation().thumbnail(it, call.argumentOrThrow("page")) }
                .let { result.success(it) }
        }
    )

    private fun setPage(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            getCurrentFileId()
                .let { VoxeetSDK.filePresentation().update(it, call.argumentOrThrow("page")).await() }
                .let { result.success(null) }
        }
    )

    private fun start(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            FilePresentationConverted(
                call.argumentOrThrow("name"),
                call.argumentOrThrow("id"),
                call.argumentOrThrow("size"),
                call.argumentOrThrow("imageCount")
            )
                .let { VoxeetSDK.filePresentation().start(it).await() }
                .let { result.success(null) }
        }
    )

    private fun stop(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            getCurrentFileId()
                .let { VoxeetSDK.filePresentation().stop(it).await() }
                .let { result.success(null) }
        }
    )

    private fun getCurrentFileId() = VoxeetSDK
        .conference()
        .conferenceId
        ?.let(filePresentationHolder::getPresentation)
        ?.key
        ?: throw IllegalStateException("No started file presentation")

    private fun fileFromUri(url: String): File {
        val uri = Uri.parse(url) ?: throw IllegalArgumentException("Invalid url")
        if (uri.scheme?.contains("http") == true) throw IllegalArgumentException("Unsupported url scheme")
        return createFile(uri)
    }

    private fun createFile(uri: Uri): File {
        val fileName = getFileName(uri)
        val (name, extension) = fileName?.let(::splitFileName)
            ?: throw IllegalArgumentException("Unable to get file name")
        return if (uri.scheme == "content") {
            val tempFile = File.createTempFile(name, extension).rename(fileName)
            context.contentResolver.openInputStream(uri)
                ?.use { input -> FileOutputStream(tempFile).use(input::copyTo) }
            tempFile
        } else {
            File(uri.toString())
        }
    }

    @SuppressLint("Range")
    private fun getFileName(uri: Uri): String? {
        return if (uri.scheme == "content") {
            context.contentResolver.query(uri, null, null, null, null)
                ?.use { cursor ->
                    if (cursor.moveToFirst()) cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)) else null
                }
        } else {
            val path = uri.path
            path?.lastIndexOf(File.separator)
                ?.takeIf { it != -1 }
                ?.let { path.substring(it + 1) }
        }
    }

    private fun splitFileName(name: String) =
        name.lastIndexOf(".")
            .takeIf { it != -1 }
            ?.let { name.substring(0, it) to name.substring(it) }

    private fun File.rename(newName: String): File {
        val newFile = File(parent, newName)
        if (newFile != this) {
            if (newFile.exists() && newFile.delete()) {
                Log.d("FilePresentationService", "Delete old $newName file")
            }
            if (renameTo(newFile)) {
                Log.d("FilePresentationService", "Rename file to $newName")
            }
        }
        return newFile
    }
}
