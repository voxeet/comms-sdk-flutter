package com.voxeet.asserts;

public class AssertUtils {
    public static boolean isString(Object obj) {
        String asString;
        try {
            asString = (String)obj;
        } catch (ClassCastException exception) {
            return false;
        }
        return asString != null;
    }

    public static boolean isInteger(String obj) {
        try {
            Integer.parseInt(obj);
        } catch (NumberFormatException exception) {
            return false;
        }
        return true;
    }

    public static<T> void compareWithExpectedValue(T actual, T expected, String errorMsg) throws MethodDelegate.AssertionFailed {
//        StackTraceElement[] stackTraceElements = Thread.currentThread().getStackTrace();
//        for (int i = 0; i < stackTraceElements.length; ++i) {
//            android.util.Log.d("[KB]", String.format("method: %s, line: %d", stackTraceElements[i].getMethodName(), stackTraceElements[i].getLineNumber()));
//        }
        StackTraceElement caller = Thread.currentThread().getStackTrace()[3];
        if (actual == null && expected != actual) {
            throw new MethodDelegate.AssertionFailed(actual, expected, errorMsg, caller.getFileName(), caller.getMethodName(), caller.getLineNumber());
        }
        if (!actual.getClass().isInstance(expected)) {
            throw new ClassCastException(errorMsg);
        }
        if (expected.getClass().isPrimitive() && expected != actual ) {
            throw new MethodDelegate.AssertionFailed(actual, expected, errorMsg, caller.getFileName(), caller.getMethodName(), caller.getLineNumber());
        }
        if (!expected.equals(actual)) {
            throw new MethodDelegate.AssertionFailed(actual, expected, errorMsg, caller.getFileName(), caller.getMethodName(), caller.getLineNumber());
        }

    }
}
