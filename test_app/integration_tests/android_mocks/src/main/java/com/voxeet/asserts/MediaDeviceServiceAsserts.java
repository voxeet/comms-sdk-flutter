package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;
import com.voxeet.android.media.MediaEngine;
import com.voxeet.android.media.errors.MediaEngineException;
import com.voxeet.android.media.utils.ComfortNoiseLevel;
import com.voxeet.sdk.services.ConferenceService;
import com.voxeet.sdk.services.MediaDeviceService;

import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class MediaDeviceServiceAsserts implements MethodDelegate {
    @Override
    public void onAction(String methodName, Map<String, Object> args, Result result) {
        try {
            switch (methodName) {
                case "assertGetComfortNoiseLevelArgs":
                    assertGetComfortNoiseLevelArgs(args);
                    break;
                case "assertSetComfortNoiseLevelArgs":
                    assertSetComfortNoiseLevelArgs(args);
                    break;
                case "assertSwitchCameraArgs":
                    assertSwitchCameraArgs(args);
                    break;
                case "assertSwitchDeviceSpeakerArgs":
                    assertSwitchDeviceSpeakerArgs(args);
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
        return "IntegrationTesting.MediaDeviceServiceAsserts";
    }

    private void assertGetComfortNoiseLevelArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        Object mockHasRun = VoxeetSDK.mediaDevice().getComfortNoiseLevelHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "hasRun is incorrect");
        }
        int mockArgs = VoxeetSDK.mediaDevice().level.value();
        if (!args.containsKey("noiseLevel")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockArgs, (int)args.get("noiseLevel"), "noiseLevel is incorrect");
        }

    }

    private void assertSetComfortNoiseLevelArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        int mockArgs = VoxeetSDK.mediaDevice().level.value();
        if (!args.containsKey("noiseLevel")) {
            throw new KeyNotFoundException("Key: alias not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockArgs, (int) args.get("noiseLevel"), "noiseLevel is incorrect");
        }
    }

    private void assertSwitchCameraArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockArgs = VoxeetSDK.mediaDevice().switchCameraHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("hasRun"), "hasRun is incorrect");
        }
    }

    private void assertSwitchDeviceSpeakerArgs(Map<String, Object> args) throws AssertionFailed, KeyNotFoundException {
        boolean mockArgs = VoxeetSDK.audio().local.soundManager.switchDeviceSpeakerHasRun;
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(mockArgs, args.get("hasRun"), "hasRun is incorrect");
        }
    }
}
