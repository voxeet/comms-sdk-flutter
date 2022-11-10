package com.voxeet.asserts;

import android.net.Uri;
import android.util.Pair;

import com.voxeet.VoxeetSDK;
import com.voxeet.sdk.models.v1.FilePresentationConverted;

import java.io.File;
import java.net.MalformedURLException;
import java.util.Map;

import io.dolby.asserts.AssertUtils;
import io.dolby.asserts.MethodDelegate;

public class FilePresentationServiceAsserts implements MethodDelegate {
    @Override
    public void onAction(String methodName, Map<String, Object> args, Result result) {
        try {
            switch (methodName) {
                case "assertConvertArgs":
                    assertConvertArgs(args);
                    break;
                case "assertSetPageArgs":
                    assertSetPageArgs(args);
                    break;
                case "assertStartArgs":
                    assertStartArgs(args);
                    break;
                case "assertStopArgs":
                    assertStopArgs(args);
                    break;
                case "setGetImageReturn":
                    setGetImageReturn(args);
                    break;
                case "assertGetImageArgs":
                    assertGetImageArgs(args);
                    break;
                case "setGetThumbnailReturn":
                    setGetThumbnailReturn(args);
                    break;
                case "assertGetThumbnailArgs":
                    assertGetThumbnailArgs(args);
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

    private void assertGetThumbnailArgs(Map<String, Object> args) throws AssertionFailed {
        boolean mockHasRun = VoxeetSDK.filePresentation().thumbnailHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "HasRun is incorrect");
        }

        Pair<String, Integer> mockArgs = VoxeetSDK.filePresentation().thumbnailArgs;
        if(args.containsKey("page")) {
            AssertUtils.compareWithExpectedValue(mockArgs.second, args.get("page"), "Page is incorrect");
        }
    }

    private void setGetThumbnailReturn(Map<String, Object> args) throws MalformedURLException {
        if(args.containsKey("url")) {
            VoxeetSDK.filePresentation().thumbnailReturn = new java.net.URL(args.get("url").toString());
        }
    }

    private void assertGetImageArgs(Map<String, Object> args) throws AssertionFailed {
        boolean mockHasRun = VoxeetSDK.filePresentation().imageHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "HasRun is incorrect");
        }

        Pair<String, Integer> mockArgs = VoxeetSDK.filePresentation().imageArgs;
        if(args.containsKey("page")) {
            AssertUtils.compareWithExpectedValue(mockArgs.second, args.get("page"), "Page is incorrect");
        }
    }

    private void setGetImageReturn(Map<String, Object> args) throws MalformedURLException {
        if(args.containsKey("url")) {
            VoxeetSDK.filePresentation().imageReturn = new java.net.URL(args.get("url").toString());
        }
    }

    private void assertStopArgs(Map<String, Object> args) throws AssertionFailed {
        boolean mockHasRun = VoxeetSDK.filePresentation().stopHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "HasRun is incorrect");
        }
    }

    private void assertStartArgs(Map<String, Object> args) throws AssertionFailed {
        boolean mockHasRun = VoxeetSDK.filePresentation().startHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "HasRun is incorrect");
        }

        FilePresentationConverted mockArgs = VoxeetSDK.filePresentation().startArgs;
        if(args.containsKey("id")) {
            AssertUtils.compareWithExpectedValue(mockArgs.fileId, args.get("id").toString(), "Id is incorrect");
        }

        if(args.containsKey("imageCount")) {
            AssertUtils.compareWithExpectedValue(mockArgs.nbImageConverted, AssertUtils.getInteger(args.get("imageCount")), "Image count is incorrect");
        }
    }

    private void assertSetPageArgs(Map<String, Object> args) throws AssertionFailed {
        boolean mockHasRun = VoxeetSDK.filePresentation().updateHasRun;
        if(args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "HasRun is incorrect");
        }

        Pair<String, Integer> mockArgs = VoxeetSDK.filePresentation().updateArgs;
        if(args.containsKey("page")) {
            AssertUtils.compareWithExpectedValue(mockArgs.second, args.get("page"), "Page is incorrect");
        }
    }

    @Override
    public String getName() {
        return "IntegrationTesting.FilePresentationServiceAsserts";
    }

    private void assertConvertArgs(Map<String, Object> args) throws AssertionFailed {
        boolean mockHasRun = VoxeetSDK.filePresentation().convertHasRun;
        if (args.containsKey("hasRun")) {
            AssertUtils.compareWithExpectedValue(mockHasRun, args.get("hasRun"), "HasRun is incorrect");
        }

        File mockArgs = VoxeetSDK.filePresentation().convertArgs;
        if (args.containsKey("uri")) {
            Uri authFile = Uri.parse(mockArgs.getPath());
            android.util.Log.d("[KB]", "file schema: " + authFile.getScheme());
            android.util.Log.d("[KB]", "file path: " + authFile.getPath());
            String fileName = authFile.getScheme() + "://" + authFile.getPath();
            AssertUtils.compareWithExpectedValue(fileName, (String) args.get("uri"), "Uri doesn't match");
        }
    }
}
