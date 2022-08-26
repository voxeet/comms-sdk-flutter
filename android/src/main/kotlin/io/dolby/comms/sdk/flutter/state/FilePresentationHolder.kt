package io.dolby.comms.sdk.flutter.state

import com.voxeet.sdk.services.presentation.file.FilePresentation

/**
 * [FilePresentationHolder] is started file presentations data store.
 * File presentation is stored when file presentation started, updated when corresponding event occur and removed when stopped.
 */
class FilePresentationHolder {

    private val presentationOwners = mutableMapOf<String, String>()
    private val presentations = mutableMapOf<String, FilePresentation>()

    /**
     * Store [FilePresentation] information for specific conference
     *
     * @param conferenceId conference id to store file presentation information
     * @param ownerId participant who started a file presentation
     * @param presentation file presentation information which started
     */
    fun onStarted(conferenceId: String, ownerId: String, presentation: FilePresentation) {
        presentationOwners[conferenceId] = ownerId
        presentations[conferenceId] = presentation
    }

    /**
     * Update [FilePresentation] page for specific conference
     *
     * @param conferenceId conference id to update file presentation information
     * @param position new file presentation position
     * @return updated [FilePresentation] object if exist
     */
    fun onSeek(conferenceId: String, position: Int): FilePresentation? {
        return presentations[conferenceId]?.let {
            it.page = position
            it
        }
    }

    /**
     * Remove [FilePresentation] for specific conference
     *
     * @param conferenceId conference id to remove file presentation information
     * @return removed [FilePresentation] object if exist
     */
    fun onStopped(conferenceId: String): FilePresentation? {
        presentationOwners.remove(conferenceId)
        return presentations.remove(conferenceId)
    }

    /**
     * Get [FilePresentation] information for specific conference.
     *
     * @param conferenceId conference id to get file presentation information
     */
    fun getOwnerId(conferenceId: String): String? = presentationOwners[conferenceId]

    /**
     * Get file presentation owner id from specific conference.
     *
     * @param conferenceId conference id to get file presentation owner id
     */
    fun getPresentation(conferenceId: String): FilePresentation? = presentations[conferenceId]

}
