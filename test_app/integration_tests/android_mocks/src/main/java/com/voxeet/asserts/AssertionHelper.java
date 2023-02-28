package com.voxeet.asserts;

import com.voxeet.sdk.models.Participant;

import java.util.Map;

import io.dolby.asserts.MethodDelegate;

public class AssertionHelper {
    public static void assertParticipant(Map<String, Object> args, Participant mockArgs) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        if (mockArgs == null) {
            throw new NullPointerException("Participant is null");
        }
        if (args.containsKey("id")) {
            io.dolby.asserts.AssertUtils.compareWithExpectedValue(mockArgs.getId(), args.get("id"), "Participant id is incorrect");
        }
        if (args.containsKey("participantInfo")) {
            Map<String, Object> pArgs = (Map<String, Object>) args.get("participantInfo");
            if (pArgs == null) {
                throw new NullPointerException("Particpant info is incorect");
            }
            if (!pArgs.containsKey("name")) {
                throw new KeyNotFoundException("Key: name not found");
            } else {
                io.dolby.asserts.AssertUtils.compareWithExpectedValue(mockArgs.participantInfo.getName(), args.get("id"), "Participant name is incorrect");
            }
            if (!args.containsKey("externalId")) {
                throw new KeyNotFoundException("Key: externalId not found");
            } else {
                io.dolby.asserts.AssertUtils.compareWithExpectedValue(mockArgs.participantInfo.getExternalId(), args.get("externalId"), "Participant name is incorrect");
            }
            if (!args.containsKey("avatarURL")) {
                throw new KeyNotFoundException("Key: externalId not found");
            } else {
                io.dolby.asserts.AssertUtils.compareWithExpectedValue(mockArgs.participantInfo.getAvatarUrl(), args.get("avatarURL"), "Participant name is incorrect");
            }
        }
    }
}
