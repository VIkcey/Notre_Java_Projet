package com.example.restaurant.service;

import com.example.restaurant.dao.OrderDAO;
import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.Order;
import com.example.restaurant.model.OrderItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Service class for handling order business logic.
 * Provides validation and business rules for orders.
 */
public class OrderService {
    private static final Logger logger = LoggerFactory.getLogger(OrderService.class);
    private final OrderDAO orderDAO;

    public OrderService() {
        this.orderDAO = new OrderDAO();
    }

    /**
     * Creates a new order with validation.
     *
     * @param order The order to create
     * @return The created order
     * @throws RestaurantException if validation fails or database error occurs
     */
    public Order createOrder(Order order) throws RestaurantException {
        validateOrder(order);
        logger.info("Creating new order for user: {}", order.getUserId());
        orderDAO.createOrderWithItems(order);
        return order;
    }

    /**
     * Retrieves an order by ID.
     *
     * @param id The ID of the order
     * @return The order, or null if not found
     * @throws RestaurantException if database error occurs
     */
    public Order getOrderById(int id) throws RestaurantException {
        logger.info("Retrieving order with ID: {}", id);
        Order order = orderDAO.findById(id);
        if (order == null) {
            throw new RestaurantException("Order not found with ID: " + id);
        }
        return order;
    }

    /**
     * Retrieves all orders.
     *
     * @return List of all orders
     * @throws RestaurantException if database error occurs
     */
    public List<Order> getAllOrders() throws RestaurantException {
        logger.info("Retrieving all orders");
        return orderDAO.findAll();
    }

    /**
     * Updates an existing order with validation.
     *
     * @param order The order to update
     * @return The updated order
     * @throws RestaurantException if validation fails or database error occurs
     */
    public Order updateOrder(Order order) throws RestaurantException {
        validateOrder(order);
        logger.info("Updating order with ID: {}", order.getId());
        
        // Verify order exists
        Order existingOrder = orderDAO.findById(order.getId());
        if (existingOrder == null) {
            throw new RestaurantException("Order not found with ID: " + order.getId());
        }
        
        return orderDAO.update(order);
    }

    /**
     * Deletes an order.
     *
     * @param id The ID of the order to delete
     * @throws RestaurantException if database error occurs
     */
    public void deleteOrder(int id) throws RestaurantException {
        logger.info("Deleting order with ID: {}", id);
        
        // Verify order exists
        Order order = orderDAO.findById(id);
        if (order == null) {
            throw new RestaurantException("Order not found with ID: " + id);
        }
        
        orderDAO.delete(id);
    }

    /**
     * Validates an order.
     *
     * @param order The order to validate
     * @throws RestaurantException if validation fails
     */
    private void validateOrder(Order order) throws RestaurantException {
        if (order == null) {
            throw new RestaurantException("Order cannot be null");
        }
        
        if (order.getUserId() <= 0) {
            throw new RestaurantException("Invalid user ID");
        }
        
        if (order.getTotal() < 0) {
            throw new RestaurantException("Order total cannot be negative");
        }
        
        if (order.getStatus() == null || order.getStatus().trim().isEmpty()) {
            throw new RestaurantException("Order status is required");
        }
        
        if (order.getItems() == null || order.getItems().isEmpty()) {
            throw new RestaurantException("Order must contain at least one item");
        }
        
        for (OrderItem item : order.getItems()) {
            if (item.getMenuItemId() <= 0) {
                throw new RestaurantException("Invalid menu item ID");
            }
            if (item.getQuantity() <= 0) {
                throw new RestaurantException("Item quantity must be greater than 0");
            }
            if (item.getPrice() < 0) {
                throw new RestaurantException("Item price cannot be negative");
            }
        }
    }
} 