package com.voxeet.asserts;

import com.voxeet.sdk.json.ParticipantInfo;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;
import com.voxeet.sdk.models.v1.ConferenceParticipantStatus;
import com.voxeet.sdk.models.v2.ParticipantType;
import com.voxeet.sdk.services.conference.information.ConferenceStatus;

public class ConferenceServiceAssertUtils {
    public static Conference createConference(Integer type) {
        switch (type) {
            case 1:
                return new Conference()
                    .setConferenceId("setCreateConferenceReturn_id_1")
                    .setConferenceAlias("setCreateConferenceReturn_alias_1");
            case 2:
                return new Conference()
                        .setConferenceId("setCreateConferenceReturn_id_2")
                        .setConferenceAlias("setCreateConferenceReturn_alias_2")
                        .setIsNew(true)
                        .setState(ConferenceStatus.CREATED)
                        .addParticipant(new Participant("participant_id_2",
                                new ParticipantInfo(
                            "participant_info_name_2",
                            "participant_info_external_id_2",
                            "participant_info_avatar_url_2"))
                                .setType(ParticipantType.LISTENER)
                                .setStatus(ConferenceParticipantStatus.DECLINE)
                        );
            case 3:
                return new Conference()
                        .setConferenceId("setCreateConferenceReturn_id_3")
                        .setConferenceAlias("setCreateConferenceReturn_alias_3")
                        .addParticipant(new Participant("participant_id_3",
                                new ParticipantInfo(
                                        "participant_info_name_3",
                                        "participant_info_external_id_3",
                                        "participant_info_avatar_url_3"))
                                .setType(ParticipantType.USER)
                                .setStatus(ConferenceParticipantStatus.ERROR)
                        );
            case 4:
                return new Conference()
                        .setConferenceId("setCreateConferenceReturn_id_4")
                        .setConferenceAlias("setCreateConferenceReturn_alias_4")
                        .addParticipant(new Participant("participant_id_4", new ParticipantInfo())
                                .setStatus(ConferenceParticipantStatus.CONNECTING)
                        );
            case 5:
                return new Conference()
                        .setConferenceId("setCreateConferenceReturn_id_5")
                        .setConferenceAlias("setCreateConferenceReturn_alias_5")
                        .addParticipant(new Participant("participant_id_5_1", new ParticipantInfo(
                                "participant_info_name_2",
                                "participant_info_external_id_5_1",
                                "participant_info_avatar_url_5_1"))
                                .setStatus(ConferenceParticipantStatus.DECLINE)
                                .setType(ParticipantType.LISTENER))
                        .addParticipant(new Participant("participant_id_5_2", new ParticipantInfo(
                                "participant_info_name_2",
                                "participant_info_external_id_5_2",
                                "participant_info_avatar_url_5_2"))
                                .setStatus(ConferenceParticipantStatus.ON_AIR)
                                .setType(ParticipantType.LISTENER)
                        );
            default:
                break;
        }
        return new Conference();
    }

    private static Participant createParticipant(ConferenceParticipantStatus status, ParticipantType participantType, int type) {
        return new Participant("participant_id_2",
                new ParticipantInfo(
                "participant_info_name_2",
                "participant_info_external_id_2",
                "participant_info_avatar_url_2")
        )
                .setType(ParticipantType.LISTENER)
                .setStatus(ConferenceParticipantStatus.DECLINE);
//        participant.audioReceivingFrom = true
//        participant.audioTransmitting = true);
    }
}
