package com.example.restaurant.exception;

/**
 * Custom exception class for the restaurant system.
 * This class is used to handle specific exceptions that may occur in the restaurant system.
 */
public class RestaurantException extends Exception {
    /**
     * Constructs a new RestaurantException with the specified detail message.
     *
     * @param message The detail message
     */
    public RestaurantException(String message) {
        super(message);
    }

    /**
     * Constructs a new RestaurantException with the specified detail message and cause.
     *
     * @param message The detail message
     * @param cause The cause of the exception
     */
    public RestaurantException(String message, Throwable cause) {
        super(message, cause);
    }
} 