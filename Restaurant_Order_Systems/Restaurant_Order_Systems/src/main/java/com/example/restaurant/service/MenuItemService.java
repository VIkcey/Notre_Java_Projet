package com.example.restaurant.service;

import com.example.restaurant.dao.MenuItemDAO;
import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.MenuItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.List;

/**
 * Service class for handling menu item business logic.
 * Provides validation and business rules for menu items.
 */
public class MenuItemService {
    private static final Logger logger = LoggerFactory.getLogger(MenuItemService.class);
    private final MenuItemDAO menuItemDAO;

    public MenuItemService() {
        this.menuItemDAO = new MenuItemDAO();
    }

    /**
     * Creates a new menu item with validation.
     *
     * @param menuItem The menu item to create
     * @return The created menu item
     * @throws RestaurantException if validation fails or database error occurs
     */
    public MenuItem createMenuItem(MenuItem menuItem) throws RestaurantException, SQLException {
        validateMenuItem(menuItem);
        return menuItemDAO.create(menuItem);
    }

    /**
     * Retrieves a menu item by ID.
     *
     * @param id The ID of the menu item
     * @return The menu item, or null if not found
     * @throws RestaurantException if database error occurs
     */
    public MenuItem getMenuItem(int id) throws RestaurantException, SQLException {
        return menuItemDAO.findById(id);
    }

    /**
     * Retrieves all menu items.
     *
     * @return List of all menu items
     * @throws RestaurantException if database error occurs
     */
    public List<MenuItem> getAllMenuItems() throws RestaurantException, SQLException {
        return menuItemDAO.findAll();
    }

    /**
     * Updates an existing menu item with validation.
     *
     * @param menuItem The menu item to update
     * @return The updated menu item
     * @throws RestaurantException if validation fails or database error occurs
     */
    public MenuItem updateMenuItem(MenuItem menuItem) throws RestaurantException, SQLException {
        validateMenuItem(menuItem);
        if (menuItemDAO.findById(menuItem.getId()) == null) {
            throw new RestaurantException("Menu item not found with ID: " + menuItem.getId());
        }
        return menuItemDAO.update(menuItem);
    }

    /**
     * Deletes a menu item.
     *
     * @param id The ID of the menu item to delete
     * @throws RestaurantException if database error occurs
     */
    public void deleteMenuItem(int id) throws RestaurantException, SQLException {
        if (menuItemDAO.findById(id) == null) {
            throw new RestaurantException("Menu item not found with ID: " + id);
        }
        menuItemDAO.delete(id);
    }

    /**
     * Validates a menu item.
     *
     * @param menuItem The menu item to validate
     * @throws RestaurantException if validation fails
     */
    private void validateMenuItem(MenuItem menuItem) throws RestaurantException {
        if (menuItem == null) {
            throw new RestaurantException("Menu item cannot be null");
        }
        if (menuItem.getName() == null || menuItem.getName().trim().isEmpty()) {
            throw new RestaurantException("Menu item name cannot be empty");
        }
        if (menuItem.getPrice() <= 0) {
            throw new RestaurantException("Menu item price must be greater than 0");
        }
        if (menuItem.getCategory() == null || menuItem.getCategory().trim().isEmpty()) {
            throw new RestaurantException("Menu item category cannot be empty");
        }
    }
} 