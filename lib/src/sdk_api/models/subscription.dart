/// The SubscriptionType model gathers the subscription types.
enum SubscriptionType {
  invitationReceived("SUBSCRIPTION_TYPE_INVITATION_RECEIVED"),
  activeParticipants("SUBSCRIPTION_TYPE_ACTIVE_PARTICIPANTS"),
  conferenceCreated("SUBSCRIPTION_TYPE_CONFERENCE_CREATED"),
  conferenceEnded("SUBSCRIPTION_TYPE_CONFERENCE_ENDED"),
  participantJoined("SUBSCRIPTION_TYPE_PARTICIPANT_JOINED"),
  participantLeft("SUBSCRIPTION_TYPE_PARTICIPANT_LEFT");

  final String value;

  const SubscriptionType(this.value);

  static SubscriptionType valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return SubscriptionType.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

class Subscription {
  /// The subscription type.
  SubscriptionType type;

  /// The conference alias.
  String conferenceAlias;

  Subscription(this.type, this.conferenceAlias);

  Map<String, Object?> toJson() {
    return {"type": type.value, "conferenceAlias": conferenceAlias};
  }
}
