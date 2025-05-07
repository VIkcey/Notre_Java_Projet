package com.example.restaurant.controller;

import com.example.restaurant.model.User;
import com.example.restaurant.service.UserService;
import com.example.restaurant.exception.RestaurantException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/users/*")
public class UserServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(UserServlet.class);
    private final UserService userService;
    private final ObjectMapper objectMapper;

    public UserServlet() {
        this.userService = new UserService();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all users
                List<User> users = userService.getAllUsers();
                sendJsonResponse(response, users);
            } else {
                // Get user by ID
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length == 2) {
                    int userId = Integer.parseInt(pathParts[1]);
                    User user = userService.getUserById(userId);
                    if (user != null) {
                        sendJsonResponse(response, user);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request path");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (RestaurantException e) {
            logger.error("Error processing GET request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User user = objectMapper.readValue(request.getReader(), User.class);
            User createdUser = userService.createUser(user);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdUser);
        } catch (RestaurantException e) {
            logger.error("Error creating user", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length != 2) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request path");
                return;
            }

            int userId = Integer.parseInt(pathParts[1]);
            User user = objectMapper.readValue(request.getReader(), User.class);
            user.setId(userId);

            User updatedUser = userService.updateUser(user);
            sendJsonResponse(response, updatedUser);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (RestaurantException e) {
            logger.error("Error updating user", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length != 2) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request path");
                return;
            }

            int userId = Integer.parseInt(pathParts[1]);
            userService.deleteUser(userId);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID format");
        } catch (RestaurantException e) {
            logger.error("Error deleting user", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getWriter(), data);
    }
} 