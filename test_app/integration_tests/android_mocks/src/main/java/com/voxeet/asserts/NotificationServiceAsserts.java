package com.voxeet.asserts;

import androidx.annotation.NonNull;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.json.ParticipantInvited;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.services.ConferenceService;
import com.voxeet.sdk.services.NotificationService;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class NotificationServiceAsserts implements MethodDelegate {
    @Override
    public void onAction(String methodName, Map<String, Object> args, MethodDelegate.Result result) {
        try {
            switch (methodName) {
                case "assertInviteArgs":
                    assertInviteArgs(args);
                    break;
                case "assertDeclineArgs":
                    assertDeclineArgs(args);
                    break;
                default:
                    result.error(new NoSuchMethodError());
                    return;
            }
        } catch (MethodDelegate.AssertionFailed exception) {
            //result.failed(exception);
        } catch (Exception ex) {
            result.error( ex);
        }
        result.success();
    }

    @Override
    public String getName() {
        return "IntegrationTesting.NotificationServiceAsserts";
    }

    private void assertInviteArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException{
        Object mockHasRun = VoxeetSDK.notification().inviteHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "hasRun is incorrect");
        }
        NotificationService.InviteArgs mockArgs= VoxeetSDK.notification().getInviteArgs();
        if (!args.containsKey("conference")) {
            throw new KeyNotFoundException("Key: conference not found");
        } else {
            ConferenceServiceAsserts.assertConference((Map<String, Object>) args.get("conference"), mockArgs.getConference());
        }

        ParticipantInvited mockParticipantInvited = mockArgs.getParticipantsInvited().get(0);
        if (!args.containsKey("participantInvited")) {
            throw new KeyNotFoundException("Key: participantInvited not found");
        } else {
            Map<String, Object> participantInvited = (Map<String, Object>) args.get("participantInvited");
            if (!participantInvited.containsKey("name")) {
                throw new KeyNotFoundException("Key: name not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockParticipantInvited.getParticipant().getName(), participantInvited.get("name"), "name is incorrect");
            }
            if (!participantInvited.containsKey("avatarUrl")) {
                throw new KeyNotFoundException("Key: avatarUrl not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockParticipantInvited.getParticipant().getAvatarUrl(), participantInvited.get("avatarUrl"), "avatarUrl is incorrect");
            }
            if (!participantInvited.containsKey("externalId")) {
                throw new KeyNotFoundException("Key: externalId not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockParticipantInvited.getParticipant().getExternalId(), participantInvited.get("externalId"), "externalId is incorrect");
            }
        }
    }

    private void assertDeclineArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException{
        Object mockHasRun = VoxeetSDK.notification().declineHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "hasRun is incorrect");
        }

        Conference mockArgs = VoxeetSDK.notification().declineArgs;
        if (!args.containsKey("conference")) {
            throw new KeyNotFoundException("Key: conference not found");
        } else {
            ConferenceServiceAsserts.assertConference((Map<String, Object>) args.get("conference"), mockArgs);
        }
    }
}
