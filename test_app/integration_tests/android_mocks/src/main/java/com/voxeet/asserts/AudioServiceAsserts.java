package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.android.media.utils.ComfortNoiseLevel;
import com.voxeet.sdk.models.Participant;

import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class AudioServiceAsserts implements MethodDelegate {

    @Override
    public void onAction(String methodName, Map<String, Object> args, Result result) {
        try {
            switch (methodName) {
                case "assertLocalStartArgs":
                    assertLocalStartArgs(args);
                    break;
                case "assertLocalStopArgs":
                    assertLocalStopArgs(args);
                    break;
                case "assertRemoteStartArgs":
                    assertRemoteStartArgs(args);
                    break;
                case "assertRemoteStopArgs":
                    assertRemoteStopArgs(args);
                    break;
                case "assertGetComfortNoiseLevelArgs":
                    assertGetComfortNoiseLevelArgs(args);
                    break;
                case "assertSetComfortNoiseLevelArgs":
                    assertSetComfortNoiseLevelArgs(args);
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

    @Override
    public String getName() {
        return "IntegrationTesting.AudioServiceAsserts";
    }

    private void assertLocalStartArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        boolean mockHasRun = VoxeetSDK.audio().local.startHasRun;
        if (args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "audio local not started");
        } else {
            throw new KeyNotFoundException("hasRun key not found");
        }
    }

    private void assertLocalStopArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        boolean mockHasRun = VoxeetSDK.audio().local.stopHasRun;
        if (args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "audio local not stopped");
        } else {
            throw new KeyNotFoundException("hasRun key not found");
        }
    }

    private void assertRemoteStartArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        Participant mockHasRun = VoxeetSDK.audio().remote.startArgs;
        AssertionHelper.assertParticipant(args, mockHasRun);
    }

    private void assertRemoteStopArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        Participant mockHasRun = VoxeetSDK.audio().remote.stopArgs;
        AssertionHelper.assertParticipant(args, mockHasRun);
    }

    private void assertGetComfortNoiseLevelArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        boolean mockHasRun = VoxeetSDK.mediaDevice().getComfortNoiseLevelHasRun;
        if (args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "getComfortNoise not run");
        }
        int mockArgs = VoxeetSDK.mediaDevice().level.value();
        if (args.containsKey("noiseLevel")) {
            AssertUtils.compareWithExpectedValue(mockArgs, (Integer) args.get("noiseLevel"), "incorrect noise level");
        }
    }

    private void assertSetComfortNoiseLevelArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        int mockArgs = VoxeetSDK.mediaDevice().level.value();
        if (args.containsKey("noiseLevel")) {
            AssertUtils.compareWithExpectedValue(mockArgs, (Integer) args.get("noiseLevel"), "incorrect noise level");
        }
    }
}
