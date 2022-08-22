/// The ParticipantInfo class gathers information about a conference participant.
class ParticipantInfo {
  /// The URL of the participant's avatar.
  String? avatarUrl;

  /// The external unique identifier that the customer's application can add to the participant while opening a session. This property is required to invite participants to a conference.
  /// If a participant uses the same external ID in conferences, the participant ID also remains the same across all sessions.
  String? externalId;

  /// The participant name.
  String name;

  ParticipantInfo(this.name, this.avatarUrl, this.externalId);

  /// Returns a representation of this object as a JSON object.
  Map<String, Object?> toJson() => {
    "name": name,
    "avatarUrl": avatarUrl,
    "externalId": externalId
  };
}