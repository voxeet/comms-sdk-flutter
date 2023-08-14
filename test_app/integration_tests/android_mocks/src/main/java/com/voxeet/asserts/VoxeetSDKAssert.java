package com.voxeet.asserts;

import android.util.Pair;

import com.voxeet.VoxeetSDK;
import com.voxeet.android.media.capture.audio.preview.AudioPreviewStatus;
import com.voxeet.sdk.authent.token.RefreshTokenCallback;
import com.voxeet.sdk.models.Conference;

import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

public class VoxeetSDKAssert implements MethodDelegate {
    Conference lastCreateResult = null;

    public static VoxeetSDKAssert create() {
        return new VoxeetSDKAssert();
    }

    @Override
    public void onAction(String methodName, Map<String, Object> args, MethodDelegate.Result result) {
        try {
            switch (methodName) {
                case "resetVoxeetSDK":
                    resetVoxeetSDK();
                    break;
                case "assertInitializeConsumerKeyAndSecret":
                    assertInitializeConsumerKeyAndSecret(args);
                    break;
                case "assertInitializeToken":
                    assertInitializeToken(args);
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

    private void assertInitializeToken(Map<String, Object> args) throws AssertionFailed {
        Pair<String, RefreshTokenCallback> initializeWithTokenArgs = VoxeetSDK.initializeWithTokenArgs;
        if (args.containsKey("accessToken")) {
            AssertUtils.compareWithExpectedValue(initializeWithTokenArgs.first, args.get("accessToken"), "Incorrect accessToken");
        }
    }

    private void assertInitializeConsumerKeyAndSecret(Map<String, Object> args) throws AssertionFailed {
        Pair<String, String> initializeArgs = VoxeetSDK.initializeArgs;
        if (args.containsKey("consumerKey")) {
            AssertUtils.compareWithExpectedValue(initializeArgs.first, args.get("consumerKey"), "ConsumerKey is incorrect");
        }

        if (args.containsKey("consumerSecret")) {
            AssertUtils.compareWithExpectedValue(initializeArgs.second, args.get("consumerSecret"), "ConsumerSecret is incorrect");
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
        Function1<AudioPreviewStatus, Unit> audioPreviewStatusClosure
                =  VoxeetSDK.audio().local.preview().getOnStatusChangedFunction();
        VoxeetSDK.currentInstance = new VoxeetSDK();
        VoxeetSDK.audio().local.preview().setOnStatusChangedFunction(audioPreviewStatusClosure);
    }
}
