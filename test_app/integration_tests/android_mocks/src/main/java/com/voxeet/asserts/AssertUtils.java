package com.voxeet.asserts;

import org.jetbrains.annotations.Nullable;

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
            throw new ClassCastException("Object type doesn't match, actual: " + actual.getClass().getSimpleName() + ", expected: " + expected.getClass().getSimpleName() + ", where: " + caller.getFileName() + " method: " + caller.getMethodName() + " line: " + caller.getLineNumber()) ;
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

    public static long getLong(Object x) {
        if (x instanceof Integer) {
            return ((Integer) x).longValue();
        } else if(x instanceof Float){
            return ((Float) x).longValue();
        } else if(x instanceof Long){
            return (Long) x;
        } else if(x instanceof Double){
            return ((Double) x).longValue();
        } else {
            throw new NumberFormatException("Wrong number format of object:" + x);
        }
    }

    public static int getInteger(Object x) {
        if (x instanceof Integer) {
            return ((Integer) x);
        } else if(x instanceof Float){
            return ((Float) x).intValue();
        } else if(x instanceof Long){
            return ((Long) x).intValue();
        } else if(x instanceof Double){
            return ((Double) x).intValue();
        } else {
            throw new NumberFormatException("Wrong number format of object:" + x);
        }
    }

    @Nullable
    public static String getStackInfo() {
        StackTraceElement caller = Thread.currentThread().getStackTrace()[3];
        return "where: " + caller.getFileName() + " method: " + caller.getMethodName() + " line: " + caller.getLineNumber();
    }
}
