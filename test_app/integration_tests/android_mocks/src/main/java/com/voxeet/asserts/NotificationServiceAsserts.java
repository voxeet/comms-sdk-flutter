package com.voxeet.asserts;

import android.util.Log;

import androidx.annotation.NonNull;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.json.ParticipantInvited;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.push.center.subscription.register.BaseSubscription;
import com.voxeet.sdk.services.ConferenceService;
import com.voxeet.sdk.services.NotificationService;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.util.ArrayList;
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
                case "assertSubscribeArgs":
                    assertSubscribeArgs(args);
                    break;
                case "assertUnsubscribeArgs":
                    assertUnsubscribeArgs(args);
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

    private void assertSubscribeArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException{
        boolean mockHasRun = VoxeetSDK.notification().subscribeHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockHasRun, (boolean) args.get("hasRun"), "hasRun is incorrect");
        }

        List<BaseSubscription> mockArgs = VoxeetSDK.notification().subscribeArgs;
        String conferenceAlias = VoxeetSDK.conference().getConference().getAlias();
        if (!args.containsKey("subscription")) {
            throw new KeyNotFoundException("Key: subscriptions not found");
        } else {
            Map<String, Object> subscription = (Map<String, Object>) args.get("subscription");
            if (!subscription.containsKey("type")) {
                throw new KeyNotFoundException("Key: type not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockArgs.get(0).type, subscription.get("type") , "type is incorrect");
            }
            if (!subscription.containsKey("conferenceAlias")) {
                throw new KeyNotFoundException("Key: conferenceAlias not found");
            } else {
                AssertUtils.compareWithExpectedValue(conferenceAlias, subscription.get("conferenceAlias") , "conferenceAlias is incorrect");
            }
        }
    }

    private void assertUnsubscribeArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException{
        Object mockHasRun = VoxeetSDK.notification().unsubscribeHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "hasRun is incorrect");
        }

        List<BaseSubscription> mockArgs = VoxeetSDK.notification().unsubscribeArgs;
        String conferenceAlias = VoxeetSDK.conference().getConference().getAlias();
        if (!args.containsKey("subscription")) {
            throw new KeyNotFoundException("Key: subscriptions not found");
        } else {
            Map<String, Object> subscription = (Map<String, Object>) args.get("subscription");
            if (!subscription.containsKey("type")) {
                throw new KeyNotFoundException("Key: type not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockArgs.get(0).type, subscription.get("type") , "type is incorrect");
            }
            if (!subscription.containsKey("conferenceAlias")) {
                throw new KeyNotFoundException("Key: conferenceAlias not found");
            } else {
                AssertUtils.compareWithExpectedValue(conferenceAlias, subscription.get("conferenceAlias") , "conferenceAlias is incorrect");
            }
        }
    }
}
