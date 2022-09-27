package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.services.ConferenceService;
import com.voxeet.sdk.services.builders.ConferenceCreateOptions;

import java.util.Map;

public class ConferenceServiceAsserts implements MethodDelegate {
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
                default:
                    result.error(new NoSuchMethodError());
                    return;
            }
        } catch (AssertionFailed exception) {
            result.failed(exception);
        } catch (Exception ex) {
            result.error( ex);
        }
        result.success();
    }

    @Override
    public String getName() {
        return "IntegrationTesting.ConferenceServiceAsserts";
    }

    private void setCreateConferenceReturn(Map<String, Object> args) throws KeyNotFoundException {
        if (!args.containsKey("type")) {
            throw new KeyNotFoundException("Missing key: type");
        }
        ConferenceService.setMockConference((int)args.get("type"));
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
        if (args.containsKey("params_dolby")) {
            throw new KeyNotFoundException("Key: params_dolby not found");
        }
        if (args.containsKey("params_liveRecording")) {
            throw new KeyNotFoundException("Key: params_liveRecording not found");
        }
        if (args.containsKey("params_rtcpMode")) {
            throw new KeyNotFoundException("Key: params_rtcpMode not found");
        }
        if (args.containsKey("params_ttl")) {
            throw new KeyNotFoundException("Key: params_ttl not found");
        }
        if (args.containsKey("params_videoCodec")) {
            throw new KeyNotFoundException("Key: params_ttl not found");
        }
        if (args.containsKey("pin")) {
            throw new KeyNotFoundException("Key: params_ttl not found");
        }

    }
}
