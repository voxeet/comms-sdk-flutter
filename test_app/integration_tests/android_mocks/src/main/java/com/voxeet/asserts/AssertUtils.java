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

    public static void compareWithExpectedValue(Object actual, Object expected, String errorMsg) throws MethodDelegate.AssertionFailed {
        if (!actual.getClass().isInstance(expected)) {
            throw new ClassCastException(errorMsg);
        }
        if (expected.getClass().isPrimitive() && expected != actual ) {
            throw new MethodDelegate.AssertionFailed(actual, expected, errorMsg, null, null, null);
        }
        if (!expected.equals(actual)) {
            throw new MethodDelegate.AssertionFailed(actual, expected, errorMsg, null, null, null);
        }

    }
}
