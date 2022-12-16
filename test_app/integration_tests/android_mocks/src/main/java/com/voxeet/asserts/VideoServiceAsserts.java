package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.models.Participant;

import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class VideoServiceAsserts implements MethodDelegate {
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
        return "IntegrationTesting.VideoServiceAsserts";
    }

    private void assertLocalStartArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        boolean mockHasRun = VoxeetSDK.video().local.startHasRun;
        if (args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "audio local not started");
        } else {
            throw new KeyNotFoundException("hasRun key not found");
        }
    }

    private void assertLocalStopArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        boolean mockHasRun = VoxeetSDK.video().local.stopHasRun;
        if (args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "audio local not stopped");
        } else {
            throw new KeyNotFoundException("hasRun key not found");
        }
    }

    private void assertRemoteStartArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        Participant mockHasRun = VoxeetSDK.video().remote.startArgs;
        AssertionHelper.assertParticipant(args, mockHasRun);
    }

    private void assertRemoteStopArgs(Map<String, Object> args) throws KeyNotFoundException, MethodDelegate.AssertionFailed {
        Participant mockHasRun = VoxeetSDK.video().remote.stopArgs;
        AssertionHelper.assertParticipant(args, mockHasRun);
    }
}
