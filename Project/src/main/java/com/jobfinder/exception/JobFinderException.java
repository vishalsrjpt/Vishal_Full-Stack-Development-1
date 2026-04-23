package com.jobfinder.exception;

public class JobFinderException extends Exception {

    private final int errorCode;

    public JobFinderException(String message, int errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

    public JobFinderException(String message, int errorCode, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
    }

    public int getErrorCode() { return errorCode; }
}