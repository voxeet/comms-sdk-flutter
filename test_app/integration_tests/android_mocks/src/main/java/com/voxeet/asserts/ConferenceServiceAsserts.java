package com.voxeet.asserts;

import static java.lang.System.in;

import android.util.Pair;

import com.voxeet.VoxeetSDK;
import com.voxeet.android.media.spatialisation.SpatialDirection;
import com.voxeet.android.media.spatialisation.SpatialEnvironment;
import com.voxeet.android.media.spatialisation.SpatialPosition;
import com.voxeet.android.media.spatialisation.SpatialScale;
import com.voxeet.sdk.json.ConferencePermission;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;
import com.voxeet.sdk.models.ParticipantPermissions;
import com.voxeet.sdk.services.ScreenShareService;
import com.voxeet.sdk.services.builders.ConferenceCreateOptions;
import com.voxeet.sdk.services.builders.ConferenceJoinOptions;
import com.voxeet.sdk.services.conference.AudioProcessing;

import java.util.List;
import java.util.Map;
import java.util.Set;

public class ConferenceServiceAsserts implements MethodDelegate {

    @Override
    public String getName() {
        return "IntegrationTesting.ConferenceServiceAsserts";
    }

    @Override
    public void onAction(String methodName, Map<String, Object> args, MethodDelegate.Result result) {
        try {
            switch (methodName) {
                case "setCreateConferenceReturn":
                    setCreateConferenceReturn(args);
                    break;
                case "assertCreateConferenceArgs":
                    assertCreateConferenceArgs(args);
                    break;
                case "setFetchConferenceReturn":
                    setFetchConferenceReturn(args);
                    break;
                case "assertFetchConferenceArgs":
                    assertFetchConferenceArgs(args);
                    break;
                case "setJoinConferenceReturn":
                    setJoinConferenceReturn(args);
                    break;
                case "assertJoinConfrenceArgs":
                    assertJoinConfrenceArgs(args);
                    break;
                case "setCurrentConference":
                    setCurrentConference(args);
                    break;
                case "assertKickArgs":
                    assertKickArgs(args);
                    break;
                case "assertLeaveArgs":
                    assertLeaveArgs(args);
                    break;
                case "assertAudioLevelArgs":
                    assertAudioLevelArgs(args);
                    break;
                case "setAudioLevelReturn":
                    setAudioLevelReturn(args);
                    break;
                case "setMaxVideoForwardingReturn":
                    setMaxVideoForwardingReturn(args);
                    break;
                case "assertStartAudioConferenceArgs":
                    assertStartAudioConferenceArgs(args);
                    break;
                case "assertStopAudioConferenceArgs":
                    assertStopAudioConferenceArgs(args);
                    break;
                case "assertStartVideoConferenceArgs":
                    assertStartVideoConferenceArgs(args);
                    break;
                case "assertStopVideoConferenceArgs":
                    assertStopVideoConferenceArgs(args);
                    break;
                case "assertStartScreeenShareArgs":
                    assertStartScreeenShareArgs(args);
                    break;
                case "assertReplayConferenceArgs":
                    assertReplayConferenceArgs(args);
                    break;
                case "assertSetSpatialPositionArgs":
                    assertSetSpatialPositionArgs(args);
                    break;
                case "assertSetSpatialEnvironmentArgs":
                    assertSetSpatialEnvironmentArgs(args);
                    break;
                case "assertSetSpatialDirectionArgs":
                    assertSetSpatialDirectionArgs(args);
                    break;
                case "assertMuteConferenceArgs":
                    assertMuteConferenceArgs(args);
                    break;
                case "assertMuteOutputArgs":
                    assertMuteOutputArgs(args);
                    break;
                case "setIsMuted":
                    setIsMuted(args);
                    break;
                case "setIsSpeaking":
                    setIsSpeaking(args);
                    break;
                case "assertIsSpeaking":
                    assertIsSpeaking(args);
                    break;
                case "assertSetMaxVideoForwardingArgs":
                    assertSetMaxVideoForwardingArgs(args);
                    break;
                case "assertSetAudioProcessing":
                    assertSetAudioProcessing(args);
                    break;
                case "assertUpdatePermissions":
                    assertUpdatePermissions(args);
                    break;
                default:
                    result.error(new NoSuchMethodError("Method: " + methodName + " not found in " + getName() + " method channel"));
                    return;
            }
            result.success();
        } catch (AssertionFailed exception) {
            result.failed(exception);
        } catch (Exception ex) {
            result.error(ex);
        }
    }

    private void assertUpdatePermissions(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        List<ParticipantPermissions> mockPermissions = VoxeetSDK.conference().updatePermissionsArgs;
        if(args.containsKey("updatePermissions")) { 
            List<Map<String, Object>> updatePermission = (List<Map<String, Object>>) args.get("updatePermissions");
            for (int i =0; i < updatePermission.size(); ++i) {
                assertParticipantPermissions(updatePermission.get(i), mockPermissions.get(i));
            }
        }
    }

    private void assertParticipantPermissions(Map<String, Object> args, ParticipantPermissions mockPermissions) throws AssertionFailed, KeyNotFoundException {
        if(args.containsKey("participant")) { 
            assertParticipant((Map<String, Object>) args.get("participant"), mockPermissions.participant);
        }

        if(args.containsKey("permissions")) {
            ConferencePermission[] permissions = new ConferencePermission[0];
            assertConferencePermissions((List<Integer>) args.get("permissions"), mockPermissions.permissions.toArray(permissions));
        }
    }

    private void assertConferencePermissions(List<Integer> args, ConferencePermission[] mockPermissions) throws AssertionFailed {
        for (int i =0 ; i < args.size(); ++i ) {
            assertConferencePermission(args.get(i), mockPermissions[i]);
        }
    }

    private void assertConferencePermission(Integer args, ConferencePermission mockPermission) throws AssertionFailed {
        AssertUtils.compareWithExpectedValue(mockPermission.ordinal(), args, "RawValue is incorrect");
    }

    private void assertSetAudioProcessing(Map<String, Object> args) throws AssertionFailed {
        AudioProcessing mockAudioProcessing = VoxeetSDK.conference().audioProcessingArgs;
        assertAudioProcessing(args, mockAudioProcessing);
    }

    private void assertAudioProcessing(Map<String, Object> args, AudioProcessing mockAudioProcessing) throws AssertionFailed {
        if(args.containsKey("value")) {
            if ((Boolean)args.get("value")) {
                AssertUtils.compareWithExpectedValue(mockAudioProcessing, AudioProcessing.VOICE, "Audio processing is incorrect");
            } else {
                AssertUtils.compareWithExpectedValue(mockAudioProcessing, AudioProcessing.ENVIRONMENT, "Audio processing is incorrect");
            }

        }
    }

    private void assertSetMaxVideoForwardingArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Pair<List<Participant>, Integer> mockArgs = VoxeetSDK.conference().videoForwardingArgs;
        if (mockArgs == null) {
            throw new NullPointerException("videoForwardingArgs is null, probably videoForwarding method didn't call");
        }

        if(args.containsKey("max")) {
            AssertUtils.compareWithExpectedValue(mockArgs.second, args.get("max"), "max is incorrect");
        }
        if (args.containsKey("prioritizedParticipants")) {
            Map<String, Object> participant = (Map<String, Object>) args.get("prioritizedParticipants");
            Participant first = mockArgs.first.size() > 0 ? mockArgs.first.get(0) : null;
            assertParticipant(participant, first);
        }
    }

    private void assertIsSpeaking(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockParticipant = VoxeetSDK.conference().speakingArgs;
        if (mockParticipant == null) {
            throw new NullPointerException("speakingArgs is null, probably isSpeaking method didn't call");
        }
        assertParticipant(args, mockParticipant);
    }

    private void setIsSpeaking(Map<String, Object> args) {
        if(args.containsKey("isSpeaking")) {
            VoxeetSDK.conference().isSpeakingReturn = (Boolean)args.get("isSpeaking");
        }
    }

    private void setIsMuted(Map<String, Object> args) {
        if(args.containsKey("isMuted")) {
            VoxeetSDK.conference().isMutedReturn = (Boolean)args.get("isMuted");
        }
    }

    private void assertMuteConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Pair<Participant, Boolean> mockArgs = VoxeetSDK.conference().muteArgs;
        if (mockArgs == null) {
            throw new NullPointerException("Mute arguments is null, probably mute method didn't call");
        }
        assertParticipant(args, mockArgs.first);
        if(args.containsKey("isMuted")) {
            AssertUtils.compareWithExpectedValue(mockArgs.second, args.get("isMuted"), "isMutes incorrect value");
        }
    }

    private void assertMuteOutputArgs(Map<String, Object> args) throws AssertionFailed {
        boolean muteMockArgs = VoxeetSDK.conference().muteOutputArgs;
        if (args.containsKey("isMuted")) {
            AssertUtils.compareWithExpectedValue(muteMockArgs, args.get("isMuted"), "isMuted has incorrect value");
        }
    }

    private void assertSetSpatialEnvironmentArgs(Map<String, Object> args) throws AssertionFailed {
        SpatialEnvironment spatialEnvironment = VoxeetSDK.conference().spatialEnvironmentArgs;
        if (spatialEnvironment == null) {
            throw new NullPointerException("SpatialEnvironment is null, probably setSpatialEnvironment didn't call");
        }
        SpatialScale mockScale = spatialEnvironment.scale;
        if(args.containsKey("scale")) {
            assertSpatialScale((Map<String, Object>) args.get("scale"), mockScale);
        }
        SpatialPosition mockForward = spatialEnvironment.forward;
        if(args.containsKey("forward")) {
            assertSpatialPosition((Map<String, Object>) args.get("forward"), mockForward);
        }
        SpatialPosition mockUp = spatialEnvironment.up;
        if(args.containsKey("up")) {
            assertSpatialPosition((Map<String, Object>) args.get("up"), mockUp);
        }
        SpatialPosition mockRight = spatialEnvironment.right;
        if(args.containsKey("right")) {
            assertSpatialPosition((Map<String, Object>) args.get("right"), mockRight);
        }
    }

    private void assertSpatialScale(Map<String, Object> args, SpatialScale mockScale) throws AssertionFailed {
        if(args.containsKey("x")) {
            double x = AssertUtils.getDouble(args.get("x"));
            AssertUtils.compareWithExpectedValue(mockScale.x, x, "X incorrect value");
        }

        if(args.containsKey("y")) {
            double y = AssertUtils.getDouble(args.get("y"));
            AssertUtils.compareWithExpectedValue(mockScale.y, y, "Y incorrect value");
        }

        if(args.containsKey("z")) {
            double z = AssertUtils.getDouble(args.get("z"));
            AssertUtils.compareWithExpectedValue(mockScale.z, z, "Z incorrect value");
        }
    }

    private void assertSetSpatialDirectionArgs(Map<String, Object> args) throws AssertionFailed {
        SpatialDirection mockPosition = VoxeetSDK.conference().spatialDirectionArgs;
        if(args.containsKey("x")) {
            double x = AssertUtils.getDouble(args.get("x"));
            AssertUtils.compareWithExpectedValue(mockPosition.x, x, "X incorrect value");
        }

        if(args.containsKey("y")) {
            double y = AssertUtils.getDouble(args.get("y"));
            AssertUtils.compareWithExpectedValue(mockPosition.y, y, "Y incorrect value");
        }

        if(args.containsKey("z")) {
            double z = AssertUtils.getDouble(args.get("z"));
            AssertUtils.compareWithExpectedValue(mockPosition.z, z, "Z incorrect value");
        }
    }

    private void assertSetSpatialPositionArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockParticipant = VoxeetSDK.conference().spatialPositionArgs.first;
        if (args.containsKey("participant")) {
            assertParticipant((Map<String, Object>) args.get("participant"), mockParticipant);
        }
        SpatialPosition mockPosition = VoxeetSDK.conference().spatialPositionArgs.second;
        if (args.containsKey("position")) {
            assertSpatialPosition((Map<String, Object>) args.get("position"), mockPosition);
        }
    }

    private void assertSpatialPosition(Map<String, Object> args, SpatialPosition mockPosition) throws AssertionFailed {
        if(args.containsKey("x")) {
            double x = AssertUtils.getDouble(args.get("x"));
            AssertUtils.compareWithExpectedValue(mockPosition.x, x, "X incorrect value");
        }

        if(args.containsKey("y")) {
            double y = AssertUtils.getDouble(args.get("y"));
            AssertUtils.compareWithExpectedValue(mockPosition.y, y, "Y incorrect value");
        }

        if(args.containsKey("z")) {
            double z = AssertUtils.getDouble(args.get("z"));
            AssertUtils.compareWithExpectedValue(mockPosition.z, z, "Z incorrect value");
        }
    }

    private void assertReplayConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Pair<Conference, Long> mockArgs = VoxeetSDK.conference().replayArgs;
        if (args.containsKey("conference")) {
            assertConference(args, mockArgs.first);
        }
        if (args.containsKey("offset")) {
            Long expectedOffset = ((Integer) args.get("offset")).longValue();
            AssertUtils.compareWithExpectedValue(mockArgs.second, expectedOffset, "offset is incorrect");
        }
    }

    private void assertStartScreeenShareArgs(Map<String, Object> args) throws AssertionFailed {
        if (args.containsKey("broadcast")) {
            AssertUtils.compareWithExpectedValue(VoxeetSDK.screenShare().broadcast, (Boolean) args.get("broadcast"), "Broadcast is incorrect");
        }
    }

    private void assertStopAudioConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockArgs = VoxeetSDK.conference().stopAudioArgs;
        assertParticipant(args, mockArgs);
    }

    private void assertStartAudioConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockArgs = VoxeetSDK.conference().startAudioArgs;
        assertParticipant(args, mockArgs);
    }

    private void assertStopVideoConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockArgs = VoxeetSDK.conference().stopVideoArgs;
        assertParticipant(args, mockArgs);
    }

    private void assertStartVideoConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockArgs = VoxeetSDK.conference().startVideoArgs;
        assertParticipant(args, mockArgs);
    }

    private void setMaxVideoForwardingReturn(Map<String, Object> args) {
        if(args.containsKey("value")) {
            VoxeetSDK.conference().maxVideoForwardingReturn = ((Integer) args.get("value"));
        }
    }

    private void setAudioLevelReturn(Map<String, Object> args) {
        if(args.containsKey("value")) {
            VoxeetSDK.conference().audioLevelReturn = ((Integer) args.get("value")).floatValue();
        }
    }

    private void assertAudioLevelArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockArgs = VoxeetSDK.conference().audioLevelArgs;
        assertParticipant(args, mockArgs);
    }

    private void assertLeaveArgs(Map<String, Object> args) throws KeyNotFoundException, AssertionFailed {
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(args.get("hasRun"), VoxeetSDK.conference().leaveHasRun, "HasRun is incorrect");
        }
    }

    private void assertKickArgs(Map<String, Object> args) throws KeyNotFoundException, AssertionFailed {
        Participant mockArgs = VoxeetSDK.conference().kickArgs;
        assertParticipant(args, mockArgs);
    }

    public void assertParticipant(Map<String, Object> args, Participant mockArgs) throws KeyNotFoundException, AssertionFailed {
        if (mockArgs == null) {
            throw new NullPointerException("Participant is null");
        }
        if (args.containsKey("id")) {
            AssertUtils.compareWithExpectedValue(mockArgs.getId(), args.get("id"), "Participant id is incorrect");
        }
        if (args.containsKey("participantInfo")) {
            Map<String, Object> pArgs = (Map<String, Object>) args.get("participantInfo");
            if (pArgs == null) {
                throw new NullPointerException("Particpant info is incorect");
            }
            if (!pArgs.containsKey("name")) {
                throw new KeyNotFoundException("Key: name not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockArgs.participantInfo.getName(), args.get("id"), "Participant name is incorrect");
            }
            if (!args.containsKey("externalId")) {
                throw new KeyNotFoundException("Key: externalId not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockArgs.participantInfo.getExternalId(), args.get("externalId"), "Participant name is incorrect");
            }
            if (!args.containsKey("avatarURL")) {
                throw new KeyNotFoundException("Key: externalId not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockArgs.participantInfo.getAvatarUrl(), args.get("avatarURL"), "Participant name is incorrect");
            }
        }
    }

    private void setCurrentConference(Map<String, Object> args) throws KeyNotFoundException {
        if (!args.containsKey("type")) {
            throw new KeyNotFoundException("Missing key: type");
        }
        VoxeetSDK.conference().current = ConferenceServiceAssertUtils.createConference((Integer)args.get("type"));
    }

    private void assertJoinConfrenceArgs(Map<String, Object> args) throws KeyNotFoundException, AssertionFailed {
        ConferenceJoinOptions joinArgs = VoxeetSDK.conference().joinArgs;
        if (joinArgs == null) {
            throw new AssertionFailed(
                    null,
                    "<ConferenceJoinOptions>",
                    "Join Arguments is null",
                    "ConferenceServiceAsserts.java",
                    "assertJoinConfrenceArgs",
                    0
            );
        }
        if (!args.containsKey("conference")) {
            throw new KeyNotFoundException("Key: alias not found");
        } else {
            assertConference((Map<String, Object>) args.get("conference"), joinArgs.conference);
        }

        if (!args.containsKey("joinOptions")) {
            throw new KeyNotFoundException("Key: alias not found");
        } else {
            assertJoinOptions((Map<String, Object>)args.get("joinOptions"), joinArgs);
        }
    }

    public static void assertConference(Map<String, Object> args, Conference mockConference) throws KeyNotFoundException, AssertionFailed {
        if (args.containsKey("id")) {
            AssertUtils.compareWithExpectedValue(mockConference.getId(), args.get("id"), "Conference id is incorrect");
        }
        if (args.containsKey("conferenceId")) {
            AssertUtils.compareWithExpectedValue(mockConference.getId(), args.get("conferenceId"), "Conference id is incorrect");
        }
        if (args.containsKey("alias")) {
            AssertUtils.compareWithExpectedValue(mockConference.getAlias(), args.get("alias"), "Conference alias is incorrect");
        }
        if (args.containsKey("isNew")) {
            AssertUtils.compareWithExpectedValue(mockConference.isNew(), args.get("isNew"), "Conference isNew is incorrect");
        }
        if (args.containsKey("status")) {
            AssertUtils.compareWithExpectedValue(mockConference.getState(), args.get("status"), "Conference status is incorrect");
        }
    }

    private void assertJoinOptions(Map<String, Object> args, ConferenceJoinOptions mockJoinOptions) throws KeyNotFoundException, AssertionFailed {
        if (!args.containsKey("conferenceAccessToken")) {
            throw new KeyNotFoundException("Key: conferenceAccessToken not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockJoinOptions.conferenceAccessToken, args.get("conferenceAccessToken"), "Conference access token is incorrect");
        }
        if (!args.containsKey("constraints")) {
            throw new KeyNotFoundException("Key: constraints not found");
        } else {
            Map<String, Object> constraints = (Map<String, Object>)args.get("constraints");
            if (!constraints.containsKey("audio")) {
                throw new KeyNotFoundException("Key: audio not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockJoinOptions.constraints.audio, constraints.get("audio"), "Conference audio is incorrect");
            }
            if (!constraints.containsKey("video")) {
                throw new KeyNotFoundException("Key: audio not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockJoinOptions.constraints.video, constraints.get("video"), "Conference video is incorrect");
            }
        }
        if (!args.containsKey("maxVideoForwarding")) {
            throw new KeyNotFoundException("Key: alias not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockJoinOptions.maxForwarding, args.get("maxVideoForwarding"), "Max video forwarding is incorrect");
        }
        if (!args.containsKey("spatialAudio")) {
            throw new KeyNotFoundException("Key: alias not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockJoinOptions.spatialAudio, args.get("spatialAudio"), "Spatial audio is incorrect");
        }
    }

    private void setJoinConferenceReturn(Map<String, Object> args) throws KeyNotFoundException  {
        if (!args.containsKey("type")) {
            throw new KeyNotFoundException("Missing key: type");
        }
        VoxeetSDK.conference().joinReturn = ConferenceServiceAssertUtils.createConference((Integer)args.get("type"));
    }

    private void setFetchConferenceReturn(Map<String, Object> args) throws KeyNotFoundException {
        if (!args.containsKey("type")) {
            throw new KeyNotFoundException("Missing key: type");
        }
        VoxeetSDK.conference().fetchReturn = ConferenceServiceAssertUtils.createConference((Integer)args.get("type"));
    }

    private void setCreateConferenceReturn(Map<String, Object> args) throws KeyNotFoundException {
        if (!args.containsKey("type")) {
            throw new KeyNotFoundException("Missing key: type");
        }
        VoxeetSDK.conference().createReturn = ConferenceServiceAssertUtils.createConference((Integer) args.get("type"));
    }

    private void assertCreateConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        ConferenceCreateOptions createArgs = VoxeetSDK.conference().createArgs;
        if (createArgs == null) {
            throw new NullPointerException("createArgs is null");
        }
        if (!args.containsKey("alias")) {
            throw new KeyNotFoundException("Key: alias not found");
        } else {
            AssertUtils.compareWithExpectedValue(createArgs.getAlias(), args.get("alias"), "Alias is incorrect");
        }
        if (!args.containsKey("params_dolby")) {
            throw new KeyNotFoundException("Key: params_dolby not found");
        } else {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().isDolbyVoice(), args.get("params_dolby"), "DolbyVoice is incorrect");
        }
        if (!args.containsKey("params_liveRecording")) {
            throw new KeyNotFoundException("Key: params_liveRecording not found");
        } else {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().isLiveRecording(), args.get("params_liveRecording"), "LiveRecording is incorrect");
        }
        if (!args.containsKey("params_rtcpMode")) {
            throw new KeyNotFoundException("Key: params_rtcpMode not found");
        } else {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().getRtcpMode(), args.get("params_rtcpMode"), "RtcpMode is incorrect");
        }
        if (!args.containsKey("params_ttl")) {
            throw new KeyNotFoundException("Key: params_ttl not found");
        } else {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().getTtl(), args.get("params_ttl"), "Ttl is incorrect");
        }
        if (args.containsKey("params_videoCodec")) {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().getVideoCodec(), args.get("params_videoCodec"), "VideoCodec is incorrect");
        }

        if (args.containsKey("params_videoCodec2")) {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().getVideoCodec(), args.get("params_videoCodec2"), "VideoCodec is incorrect");
        }
    }

    private void assertFetchConferenceArgs(Map<String, Object> args) throws KeyNotFoundException, AssertionFailed {
        String fetchArgs = VoxeetSDK.conference().fetchArgs;
        if (!args.containsKey("conferenceId")) {
            throw new KeyNotFoundException("Key: params_videoCodec not found");
        } else {
            AssertUtils.compareWithExpectedValue(fetchArgs, args.get("conferenceId"), "ConferenceId is incorrect");
        }
    }
}
