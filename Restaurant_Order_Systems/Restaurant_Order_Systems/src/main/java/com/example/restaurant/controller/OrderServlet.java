package com.example.restaurant.controller;

import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.Order;
import com.example.restaurant.model.OrderItem;
import com.example.restaurant.service.OrderService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling order operations.
 * Provides RESTful endpoints for order management.
 */
@WebServlet("/api/orders/*")
public class OrderServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(OrderServlet.class);
    private final OrderService orderService;
    private final ObjectMapper objectMapper;

    public OrderServlet() {
        this.orderService = new OrderService();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all orders
                List<Order> orders = orderService.getAllOrders();
                logger.info("Retrieved {} orders", orders.size());
                sendJsonResponse(response, orders);
            } else {
                // Get order by ID
                String orderId = pathInfo.substring(1);
                Order order = orderService.getOrderById(Integer.parseInt(orderId));
                if (order != null) {
                    logger.info("Retrieved order with ID: {}", orderId);
                    sendJsonResponse(response, order);
                } else {
                    logger.warn("Order not found with ID: {}", orderId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                }
            }
        } catch (RestaurantException e) {
            logger.error("Error processing GET request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Order order = objectMapper.readValue(request.getReader(), Order.class);
            Order createdOrder = orderService.createOrder(order);
            logger.info("Created new order with ID: {}", createdOrder.getId());
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdOrder);
        } catch (RestaurantException e) {
            logger.error("Error processing POST request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
                return;
            }

            String orderId = pathInfo.substring(1);
            Order order = objectMapper.readValue(request.getReader(), Order.class);
            order.setId(Integer.parseInt(orderId));

            Order updatedOrder = orderService.updateOrder(order);
            logger.info("Updated order with ID: {}", orderId);
            sendJsonResponse(response, updatedOrder);
        } catch (RestaurantException e) {
            logger.error("Error processing PUT request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID is required");
                return;
            }

            String orderId = pathInfo.substring(1);
            orderService.deleteOrder(Integer.parseInt(orderId));
            logger.info("Deleted order with ID: {}", orderId);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (RestaurantException e) {
            logger.error("Error processing DELETE request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
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
        objectMapper.writeValue(response.getWriter(), data);
    }
}
