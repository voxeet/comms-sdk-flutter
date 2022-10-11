package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.models.Conference;

import java.util.Map;

public class VoxeetSDKAssert implements MethodDelegate {
    Conference lastCreateResult = null;

    public static VoxeetSDKAssert create() {
        return new VoxeetSDKAssert();
    }

    @Override
    public void onAction(String methodName, Map<String, Object> args, MethodDelegate.Result result) {
        switch (methodName) {
            case "resetVoxeetSDK":
                resetVoxeetSDK();
                result.success();
                break;
            default:
                result.error(new NoSuchMethodError());
                return;
        }
    }

    @Override
    public String getName() {
        return "IntegrationTesting.VoxeetSDKAsserts";
    }

    private void resetVoxeetSDK() {
        clearConferenceService();
    }

    private void clearConferenceService() {
        VoxeetSDK.conference().joinArgs = null;
        VoxeetSDK.conference().kickArgs = null;
        VoxeetSDK.conference().createArgs = null;
        VoxeetSDK.conference().createReturn = null;
        VoxeetSDK.conference().leaveHasRun = false;
        VoxeetSDK.session().closeHasRun = false;
    }
}
