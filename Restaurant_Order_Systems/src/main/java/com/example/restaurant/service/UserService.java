package com.example.restaurant.service;

import com.example.restaurant.dao.UserDAO;
import com.example.restaurant.model.User;
import com.example.restaurant.exception.RestaurantException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User createUser(User user) throws RestaurantException {
        validateUser(user);
        checkDuplicateUsername(user.getUsername());
        checkDuplicateEmail(user.getEmail());
        return userDAO.create(user);
    }

    public User getUserById(int id) throws RestaurantException {
        User user = userDAO.findById(id);
        if (user == null) {
            throw new RestaurantException("User not found with ID: " + id);
        }
        return user;
    }

    public List<User> getAllUsers() throws RestaurantException {
        return userDAO.findAll();
    }

    public User updateUser(User user) throws RestaurantException {
        validateUser(user);
        User existingUser = getUserById(user.getId());
        
        // Check if username is being changed and if it's already taken
        if (!existingUser.getUsername().equals(user.getUsername())) {
            checkDuplicateUsername(user.getUsername());
        }
        
        // Check if email is being changed and if it's already taken
        if (!existingUser.getEmail().equals(user.getEmail())) {
            checkDuplicateEmail(user.getEmail());
        }

        return userDAO.update(user);
    }

    public void deleteUser(int id) throws RestaurantException {
        User user = getUserById(id);
        if (user.getRole().equals("ADMIN")) {
            throw new RestaurantException("Cannot delete admin user");
        }
        userDAO.delete(id);
    }

    private void validateUser(User user) throws RestaurantException {
        if (user == null) {
            throw new RestaurantException("User cannot be null");
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new RestaurantException("Username is required");
        }
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            throw new RestaurantException("Email is required");
        }
        if (!user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new RestaurantException("Invalid email format");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new RestaurantException("Password is required");
        }
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            throw new RestaurantException("Role is required");
        }
        if (!isValidRole(user.getRole())) {
            throw new RestaurantException("Invalid role: " + user.getRole());
        }
    }

    private void checkDuplicateUsername(String username) throws RestaurantException {
        try {
            List<User> users = userDAO.findAll();
            for (User user : users) {
                if (user.getUsername().equals(username)) {
                    throw new RestaurantException("Username already exists");
                }
            }
        } catch (RestaurantException e) {
            logger.error("Error checking duplicate username", e);
            throw e;
        }
    }

    private void checkDuplicateEmail(String email) throws RestaurantException {
        try {
            List<User> users = userDAO.findAll();
            for (User user : users) {
                if (user.getEmail().equals(email)) {
                    throw new RestaurantException("Email already exists");
                }
            }
        } catch (RestaurantException e) {
            logger.error("Error checking duplicate email", e);
            throw e;
        }
    }

    private boolean isValidRole(String role) {
        return role.equals("ADMIN") || role.equals("STAFF") || role.equals("CUSTOMER");
    }
} 