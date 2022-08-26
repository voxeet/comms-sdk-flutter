package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.services.presentation.file.FilePresentation

class FileConvertedMapper(
    private val ownerId: String,
    private val fileName: String,
    private val filePresentation: FilePresentation
) : Mapper() {
    override fun convertToMap() = mapOf(
        "id" to filePresentation.key,
        "name" to fileName,
        "ownerId" to ownerId,
        "url" to filePresentation.url,
        "imageCount" to filePresentation.nbPage,
        "size" to 0.0
    )
}
