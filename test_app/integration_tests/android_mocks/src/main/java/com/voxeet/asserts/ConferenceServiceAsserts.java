package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.models.Conference;
import com.voxeet.sdk.models.Participant;
import com.voxeet.sdk.services.builders.ConferenceCreateOptions;
import com.voxeet.sdk.services.builders.ConferenceJoinOptions;

import java.util.Map;

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

    private void assertStartAudioConferenceArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Participant mockArgs = VoxeetSDK.conference().startAudioArgs;
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
        if (!args.containsKey("id")) {
            throw new KeyNotFoundException("Key: conference id not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockConference.getId(), args.get("id"), "Conference id is incorrect");
        }
        if (!args.containsKey("alias")) {
            throw new KeyNotFoundException("Key: conference alias not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockConference.getAlias(), args.get("alias"), "Conference alias is incorrect");
        }

        if (!args.containsKey("isNew")) {
            throw new KeyNotFoundException("Key: conference isNew not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockConference.isNew(), args.get("isNew"), "Conference isNew is incorrect");
        }

        if (!args.containsKey("status")) {
            throw new KeyNotFoundException("Key: conference status not found");
        } else {
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
            if (!args.containsKey("audio")) {
                throw new KeyNotFoundException("Key: audio not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockJoinOptions.constraints.audio, args.get("audio"), "Conference access token is incorrect");
            }
            if (!args.containsKey("video")) {
                throw new KeyNotFoundException("Key: audio not found");
            } else {
                AssertUtils.compareWithExpectedValue(mockJoinOptions.constraints.video, args.get("video"), "Conference access token is incorrect");
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
        if (!args.containsKey("params_videoCodec")) {
            throw new KeyNotFoundException("Key: params_videoCodec not found");
        } else {
            AssertUtils.compareWithExpectedValue(createArgs.getParams().getVideoCodec(), args.get("params_videoCodec"), "VideoCodec is incorrect");
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
