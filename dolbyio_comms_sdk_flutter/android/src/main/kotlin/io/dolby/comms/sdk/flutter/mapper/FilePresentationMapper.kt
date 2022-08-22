package io.dolby.comms.sdk.flutter.mapper

import com.voxeet.sdk.models.Participant
import com.voxeet.sdk.services.presentation.file.FilePresentation

class FilePresentationMapper(private val owner: Participant, private val filePresentation: FilePresentation) : Mapper() {
    override fun convertToMap() = mapOf(
        "owner" to (of(owner)?.convertToMap() ?: emptyMap()),
        "id" to filePresentation.key,
        "imageCount" to filePresentation.nbPage,
        "position" to filePresentation.page,
    )
}
