package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.services.presentation.PresentationState;

import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class VideoPresentationServiceAsserts implements MethodDelegate {
    @Override
    public void onAction(String methodName, Map<String, Object> args, Result result) {
        try {
            switch (methodName) {
                case "assertStartArgs":
                    assertStartArgs(args);
                    break;
                case "assertStopArgs":
                    assertStopArgs(args);
                    break;
                case "assertPlayArgs":
                    assertPlayArgs(args);
                    break;
                case "assertPauseArgs":
                    assertPauseArgs(args);
                    break;
                case "assertSeekArgs":
                    assertSeekArgs(args);
                    break;
                case "assertStateArgs":
                    assertStateArgs(args);
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
        return "IntegrationTesting.VideoPresentationServiceAsserts";
    }

    public void assertStartArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockHasRun = VoxeetSDK.videoPresentation().startHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "startHasRun is incorrect");
        }

        String mockArgs = VoxeetSDK.videoPresentation().startArgs;
        if(args.containsKey("url")) {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("url"), "url is incorrect");
        }

    }

    public void assertStopArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockHasRun = VoxeetSDK.videoPresentation().stopHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "stopHasRun is incorrect");
        }
    }

    public void assertPlayArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockHasRun = VoxeetSDK.videoPresentation().playHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "playHasRun is incorrect");
        }
    }

    public void assertPauseArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockHasRun = VoxeetSDK.videoPresentation().pauseHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "pauseHasRun is incorrect");
        }

        int mockArgs = (int) VoxeetSDK.videoPresentation().pauseArgs;
        if(args.containsKey("timestamp")) {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("timestamp"), "timestamp is incorrect");
        }
    }

    public void assertSeekArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockHasRun = VoxeetSDK.videoPresentation().seekHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "seekHasRun is incorrect");
        }

        int mockArgs = (int) VoxeetSDK.videoPresentation().seekArgs;
        if(args.containsKey("timestamp")) {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("timestamp"), "timestamp is incorrect");
        }
    }

    public void assertStateArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        int mockArgs = VoxeetSDK.videoPresentation().getCurrentPresentation().state.value();
        if(args.containsKey("state")) {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("state"), "state is incorrect");
        }
    }
}
