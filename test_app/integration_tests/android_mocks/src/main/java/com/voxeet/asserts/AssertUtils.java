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

    public static double getDouble(Object x) {
        if (x instanceof Integer) {
            return ((Integer) x).doubleValue();
        } else if(x instanceof Float){
            return ((Float) x).doubleValue();
        } else if(x instanceof Long){
            return ((Long) x).doubleValue();
        } else if(x instanceof Double){
            return (Double) x;
        } else {
            throw new NumberFormatException("Wrong number format of object:" + x);
        }
    }
}
