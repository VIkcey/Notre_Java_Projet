package com.example.restaurant.dao;

import com.example.restaurant.model.User;
import com.example.restaurant.model.ConcreteUser;
import com.example.restaurant.exception.RestaurantException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends AbstractBaseDAO<User, Integer> {
    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

    private static final String CREATE_QUERY = 
        "INSERT INTO users (username, email, password, role, phone, status) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String FIND_BY_ID_QUERY = 
        "SELECT * FROM users WHERE id = ?";
    private static final String FIND_ALL_QUERY = 
        "SELECT * FROM users";
    private static final String UPDATE_QUERY = 
        "UPDATE users SET username = ?, email = ?, password = ?, role = ?, phone = ?, status = ? WHERE id = ?";
    private static final String DELETE_QUERY = 
        "DELETE FROM users WHERE id = ?";

    @Override
    protected String getCreateQuery() {
        return CREATE_QUERY;
    }

    @Override
    protected String getFindByIdQuery() {
        return FIND_BY_ID_QUERY;
    }

    @Override
    protected String getFindAllQuery() {
        return FIND_ALL_QUERY;
    }

    @Override
    protected String getUpdateQuery() {
        return UPDATE_QUERY;
    }

    @Override
    protected String getDeleteQuery() {
        return DELETE_QUERY;
    }

    @Override
    protected void setCreateParameters(PreparedStatement stmt, User user) throws SQLException {
        stmt.setString(1, user.getUsername());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPassword());
        stmt.setString(4, user.getRole());
        stmt.setString(5, user.getPhone());
        stmt.setString(6, user.getStatus());
    }

    @Override
    protected void setUpdateParameters(PreparedStatement stmt, User user) throws SQLException {
        stmt.setString(1, user.getUsername());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPassword());
        stmt.setString(4, user.getRole());
        stmt.setString(5, user.getPhone());
        stmt.setString(6, user.getStatus());
        stmt.setInt(7, user.getId());
    }

    @Override
    protected User mapResultSetToEntity(ResultSet rs) throws SQLException {
        ConcreteUser user = new ConcreteUser();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setPhone(rs.getString("phone"));
        user.setStatus(rs.getString("status"));
        return user;
    }

    public User findByUsername(String username) throws RestaurantException {
        String query = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by username", e);
            throw new RestaurantException("Error finding user by username", e);
        }
        return null;
    }

    public User findByEmail(String email) throws RestaurantException {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding user by email", e);
            throw new RestaurantException("Error finding user by email", e);
        }
        return null;
    }

    public List<User> findByRole(String role) throws RestaurantException {
        String query = "SELECT * FROM users WHERE role = ?";
        List<User> users = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding users by role", e);
            throw new RestaurantException("Error finding users by role", e);
        }
        return users;
    }

    public List<User> findByStatus(String status) throws RestaurantException {
        String query = "SELECT * FROM users WHERE status = ?";
        List<User> users = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding users by status", e);
            throw new RestaurantException("Error finding users by status", e);
        }
        return users;
    }
} 