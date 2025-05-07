package com.example.restaurant.controller;

import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.MenuItem;
import com.example.restaurant.service.MenuItemService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet for handling menu item operations.
 * Provides REST full endpoints for CRUD operations on menu items.
 */
@WebServlet("/api/menu-items/*")
public class MenuItemServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(MenuItemServlet.class);
    private final MenuItemService menuItemService;
    private final ObjectMapper objectMapper;

    public MenuItemServlet() {
        this.menuItemService = new MenuItemService();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all menu items
                List<MenuItem> items = menuItemService.getAllMenuItems();
                sendJsonResponse(response, items);
            } else {
                // Get menu item by ID
                int id = Integer.parseInt(pathInfo.substring(1));
                MenuItem item = menuItemService.getMenuItem(id);
                if (item != null) {
                    sendJsonResponse(response, item);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Menu item not found");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid menu item ID");
        } catch (RestaurantException e) {
            logger.error("Error processing GET request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            MenuItem menuItem = objectMapper.readValue(request.getInputStream(), MenuItem.class);
            MenuItem createdItem = menuItemService.createMenuItem(menuItem);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdItem);
        } catch (RestaurantException e) {
            logger.error("Error processing POST request", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Menu item ID is required");
                return;
            }

            int id = Integer.parseInt(pathInfo.substring(1));
            MenuItem menuItem = objectMapper.readValue(request.getInputStream(), MenuItem.class);
            menuItem.setId(id);
            
            MenuItem updatedItem = menuItemService.updateMenuItem(menuItem);
            sendJsonResponse(response, updatedItem);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid menu item ID");
        } catch (RestaurantException e) {
            logger.error("Error processing PUT request", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Menu item ID is required");
                return;
            }

            int id = Integer.parseInt(pathInfo.substring(1));
            menuItemService.deleteMenuItem(id);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid menu item ID");
        } catch (RestaurantException e) {
            logger.error("Error processing DELETE request", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Sends a JSON response to the client.
     *
     * @param response The HTTP response
     * @param data The data to send as JSON
     * @throws IOException if an I/O error occurs
     */
    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getOutputStream(), data);
    }
} 