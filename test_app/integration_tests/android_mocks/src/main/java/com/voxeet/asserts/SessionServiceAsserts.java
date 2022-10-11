package com.voxeet.asserts;

import com.voxeet.VoxeetSDK;

import java.util.Map;

public class SessionServiceAsserts implements MethodDelegate {
    @Override
    public void onAction(String methodName, Map<String, Object> args, Result result) {
        try {
            switch (methodName) {
                case "assertCloseArgs":
                    assertCloseArgs(args);
                    break;
                default:
                    result.error(new NoSuchMethodError("Method: " + methodName + " not found in " + getName() + " method channel"));
                    return;
            }
            result.success();
        } catch (AssertionFailed exception) {
            result.failed(exception);
        } catch (Exception ex) {
            result.error( ex);
        }
    }

    private void assertCloseArgs(Map<String, Object> args) throws KeyNotFoundException, AssertionFailed {
        if (!args.containsKey("hasRun")) {
            throw new KeyNotFoundException("Key: hasRun not found");
        } else {
            AssertUtils.compareWithExpectedValue(args.get("hasRun"), VoxeetSDK.session().closeHasRun, "HasRun is incorrect");
        }
    }

    @Override
    public String getName() {
        return "IntegrationTesting.SessionServiceAsserts";
    }
}
