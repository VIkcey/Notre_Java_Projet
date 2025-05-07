package com.example.restaurant.dao;

import com.example.restaurant.model.MenuItem;
import com.example.restaurant.util.DatabaseConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for MenuItem entities.
 * Handles all database operations related to menu items.
 */
public class MenuItemDAO {
    private static final Logger logger = LoggerFactory.getLogger(MenuItemDAO.class);
    private final DatabaseConfig dbConfig;

    public MenuItemDAO() {
        this.dbConfig = DatabaseConfig.getInstance();
    }

    public List<MenuItem> findAll() throws SQLException {
        List<MenuItem> menuItems = new ArrayList<>();
        String sql = "SELECT * FROM menu_items WHERE status = 'ACTIVE'";

        try (Connection conn = dbConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setCategory(rs.getString("category"));
                item.setStatus(rs.getString("status"));
                menuItems.add(item);
            }
        } catch (SQLException e) {
            logger.error("Error finding all menu items", e);
            throw e;
        }

        return menuItems;
    }

    public MenuItem findById(int id) throws SQLException {
        String sql = "SELECT * FROM menu_items WHERE id = ?";

        try (Connection conn = dbConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    MenuItem item = new MenuItem();
                    item.setId(rs.getInt("id"));
                    item.setName(rs.getString("name"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getDouble("price"));
                    item.setCategory(rs.getString("category"));
                    item.setStatus(rs.getString("status"));
                    return item;
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding menu item by id: " + id, e);
            throw e;
        }

        return null;
    }

    public MenuItem create(MenuItem menuItem) throws SQLException {
        String sql = "INSERT INTO menu_items (name, description, price, category, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = dbConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, menuItem.getName());
            stmt.setString(2, menuItem.getDescription());
            stmt.setDouble(3, menuItem.getPrice());
            stmt.setString(4, menuItem.getCategory());
            stmt.setString(5, menuItem.getStatus());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating menu item failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    menuItem.setId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating menu item failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            logger.error("Error creating menu item", e);
            throw e;
        }

        return menuItem;
    }

    public MenuItem update(MenuItem menuItem) throws SQLException {
        String sql = "UPDATE menu_items SET name = ?, description = ?, price = ?, category = ?, status = ? WHERE id = ?";

        try (Connection conn = dbConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, menuItem.getName());
            stmt.setString(2, menuItem.getDescription());
            stmt.setDouble(3, menuItem.getPrice());
            stmt.setString(4, menuItem.getCategory());
            stmt.setString(5, menuItem.getStatus());
            stmt.setInt(6, menuItem.getId());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating menu item failed, no rows affected.");
            }

            return menuItem;
        } catch (SQLException e) {
            logger.error("Error updating menu item: " + menuItem.getId(), e);
            throw e;
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "UPDATE menu_items SET status = 'INACTIVE' WHERE id = ?";

        try (Connection conn = dbConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting menu item failed, no rows affected.");
            }
        } catch (SQLException e) {
            logger.error("Error deleting menu item: " + id, e);
            throw e;
        }
    }
}
