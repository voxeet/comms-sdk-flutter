package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;

import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class CommandServiceAsserts implements MethodDelegate {
    @Override
    public void onAction(String methodName, Map<String, Object> args, MethodDelegate.Result result) {
        try {
            switch (methodName) {
                case "assertSendArgs":
                    assertSendArgs(args);
                    break;
                default:
                    result.error(new NoSuchMethodError("Method: " + methodName + " not found in " + getName() + " method channel"));
                    return;
            }
            result.success();
        } catch (MethodDelegate.AssertionFailed exception) {
            result.failed(exception);
        } catch (Exception ex) {
            result.error( ex);
        }
    }

    @Override
    public String getName() {
        return "IntegrationTesting.CommandServiceAsserts";
    }

    public void assertSendArgs(Map<String, Object> args) throws AssertionFailed {
        String mockSendArgs = VoxeetSDK.command().sendArgs;
        if(args.containsKey("message")) {
            AssertUtils.compareWithExpectedValue(mockSendArgs, args.get("message"), "message is incorrect");
        }
    }
}
