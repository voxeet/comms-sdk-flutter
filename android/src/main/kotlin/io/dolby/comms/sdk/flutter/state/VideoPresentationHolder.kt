package io.dolby.comms.sdk.flutter.state

import com.voxeet.sdk.models.Participant

/**
 * [VideoPresentationHolder] is started video presentations data store.
 * Video presentation owner is stored when video presentation started and removed when stopped.
 */
class VideoPresentationHolder {

  private val presentationOwners = mutableMapOf<String, Participant>()

  /**
   * Store video presentation information for specific conference
   *
   * @param conferenceId conference id to store video presentation information
   * @param owner participant who started a video presentation
   */
  fun onStarted(conferenceId: String, owner: Participant) {
    presentationOwners[conferenceId] = owner
  }

  /**
   * Remove video presentation for specific conference
   *
   * @param conferenceId conference id to remove video presentation information
   */
  fun onStopped(conferenceId: String) {
    presentationOwners.remove(conferenceId)
  }

  /**
   * Get owner for specific conference.
   *
   * @param conferenceId conference id to get video presentation owner
   */
  fun getOwner(conferenceId: String): Participant? = presentationOwners[conferenceId]
}
