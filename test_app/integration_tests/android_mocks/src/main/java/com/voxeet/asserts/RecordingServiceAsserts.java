package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.models.Participant;

import java.util.Map;

public class RecordingServiceAsserts implements MethodDelegate{
    @Override
    public void onAction(String methodName, Map<String, Object> args, Result result) {
        try {
            switch (methodName) {
                case "assertStartRecordingArgs":
                    assertStartRecordingArgs(args);
                    break;
                case "assertStopRecordingArgs":
                    assertStopRecordingArgs(args);
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
        return "IntegrationTesting.RecordingServiceAsserts";
    }

    private void assertStartRecordingArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockArgs = VoxeetSDK.recording().startHasRun;
        if(args.containsKey("hasRun") && args.get("hasRun") != null) {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("hasRun"), "hasRun is incorrect");
        }
    }

    private void assertStopRecordingArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockArgs = VoxeetSDK.recording().stopHasRun;
        if(args.containsKey("hasRun") && args.get("hasRun") != null) {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("hasRun"), "hasRun is incorrect");
        }
    }
}
