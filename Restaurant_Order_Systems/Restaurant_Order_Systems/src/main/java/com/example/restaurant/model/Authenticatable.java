package com.example.restaurant.model;

/**
 * Interface for objects that can be authenticated in the system.
 * This interface defines the contract for authentication functionality.
 */
public interface Authenticatable {
    /**
     * Authenticates a user with the given credentials.
     *
     * @param username The username to authenticate
     * @param password The password to authenticate
     * @return true if authentication is successful, false otherwise
     */
    boolean authenticate(String username, String password);

    /**
     * Gets the role of the authenticated entity.
     *
     * @return The role of the entity
     */
    String getRole();
} 