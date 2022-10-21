package io.dolby.asserts;

import java.util.Map;

public interface MethodDelegate {
    void onAction(String methodName, Map<String, Object> args, Result result);

    String getName();

    interface Result {
        void success();
        void failed(AssertionFailed failed);
        void error(Throwable throwable);
    }

    class AssertionFailed extends Exception {
        public final Object actualValue;
        public final Object expectedValue;
        public final String errorMsg;
        public final String fileName;
        public final String functionName;
        public final Integer lineNumber;

        public AssertionFailed(
                Object actualValue,
                Object expectedValue,
                String errorMsg,
                String fileName,
                String functionName,
                Integer lineNumber
        ) {
            super(errorMsg);
            this.actualValue = actualValue;
            this.expectedValue = expectedValue;
            this.errorMsg = errorMsg;
            this.fileName = fileName;
            this.functionName = functionName;
            this.lineNumber = lineNumber;
        }
    }
}
