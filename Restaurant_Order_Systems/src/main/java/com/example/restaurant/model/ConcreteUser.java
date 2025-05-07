package com.example.restaurant.model;

/**
 * Concrete implementation of the User class.
 * This class provides the actual implementation for user functionality.
 */
public class ConcreteUser extends User {
    
    public ConcreteUser() {
        super(0, "", "", "", "CUSTOMER");
    }

    public ConcreteUser(int id, String username, String email, String password, String role) {
        super(id, username, email, password, role);
    }

    @Override
    public boolean authenticate(String username, String password) {
        return super.authenticate(username, password);
    }
} 