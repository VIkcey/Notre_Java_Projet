package com.example.restaurant.dao;

import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.Order;
import com.example.restaurant.model.OrderItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Order entities.
 * Handles all database operations related to orders.
 */
public class OrderDAO extends AbstractBaseDAO<Order, Integer> {
    private static final Logger logger = LoggerFactory.getLogger(OrderDAO.class);

    private static final String CREATE_QUERY = 
        "INSERT INTO orders (user_id, total, status, created_at, special_instructions) VALUES (?, ?, ?, ?, ?)";
    private static final String CREATE_ORDER_ITEM_QUERY = 
        "INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES (?, ?, ?, ?)";
    private static final String FIND_BY_ID_QUERY = 
        "SELECT o.*, u.username as customer_name, " +
        "oi.id as item_id, oi.menu_item_id, oi.quantity, oi.price, " +
        "mi.name as item_name " +
        "FROM orders o " +
        "LEFT JOIN users u ON o.user_id = u.id " +
        "LEFT JOIN order_items oi ON o.id = oi.order_id " +
        "LEFT JOIN menu_items mi ON oi.menu_item_id = mi.id " +
        "WHERE o.id = ?";
    private static final String FIND_ALL_QUERY = 
        "SELECT o.*, u.username as customer_name, " +
        "oi.id as item_id, oi.menu_item_id, oi.quantity, oi.price, " +
        "mi.name as item_name " +
        "FROM orders o " +
        "LEFT JOIN users u ON o.user_id = u.id " +
        "LEFT JOIN order_items oi ON o.id = oi.order_id " +
        "LEFT JOIN menu_items mi ON oi.menu_item_id = mi.id " +
        "ORDER BY o.created_at DESC";
    private static final String UPDATE_QUERY = 
        "UPDATE orders SET user_id = ?, total = ?, status = ?, special_instructions = ? WHERE id = ?";
    private static final String DELETE_QUERY = 
        "DELETE FROM orders WHERE id = ?";

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
    protected void setCreateParameters(PreparedStatement stmt, Order order) throws SQLException {
        stmt.setInt(1, order.getUserId());
        stmt.setDouble(2, order.getTotal());
        stmt.setString(3, order.getStatus());
        stmt.setTimestamp(4, new Timestamp(order.getCreatedAt().getTime()));
        stmt.setString(5, order.getSpecialInstructions());
    }

    @Override
    protected void setUpdateParameters(PreparedStatement stmt, Order order) throws SQLException {
        stmt.setInt(1, order.getUserId());
        stmt.setDouble(2, order.getTotal());
        stmt.setString(3, order.getStatus());
        stmt.setString(4, order.getSpecialInstructions());
        stmt.setInt(5, order.getId());
    }

    @Override
    protected Order mapResultSetToEntity(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotal(rs.getDouble("total"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setSpecialInstructions(rs.getString("special_instructions"));
        
        // Add order item if present
        if (rs.getInt("item_id") > 0) {
            OrderItem item = new OrderItem();
            item.setId(rs.getInt("item_id"));
            item.setMenuItemId(rs.getInt("menu_item_id"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(rs.getDouble("price"));
            item.setName(rs.getString("item_name"));
            order.addItem(item);
        }
        
        return order;
    }

    @Override
    public List<Order> findAll() throws RestaurantException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getFindAllQuery());
             ResultSet rs = stmt.executeQuery()) {
            
            Order currentOrder = null;
            while (rs.next()) {
                int orderId = rs.getInt("id");
                
                if (currentOrder == null || currentOrder.getId() != orderId) {
                    if (currentOrder != null) {
                        orders.add(currentOrder);
                    }
                    currentOrder = mapResultSetToEntity(rs);
                } else {
                    // Add item to existing order
                    if (rs.getInt("item_id") > 0) {
                        OrderItem item = new OrderItem();
                        item.setId(rs.getInt("item_id"));
                        item.setMenuItemId(rs.getInt("menu_item_id"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        item.setName(rs.getString("item_name"));
                        currentOrder.addItem(item);
                    }
                }
            }
            
            if (currentOrder != null) {
                orders.add(currentOrder);
            }
            
            logger.info("Found {} orders", orders.size());
            return orders;
        } catch (SQLException e) {
            logger.error("Error finding all orders", e);
            throw new RestaurantException("Error finding all orders", e);
        }
    }

    public void createOrderWithItems(Order order) throws RestaurantException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // Create order
            try (PreparedStatement stmt = conn.prepareStatement(getCreateQuery(), new String[]{"id"})) {
                setCreateParameters(stmt, order);
                stmt.executeUpdate();
                
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setId(generatedKeys.getInt(1));
                    }
                }
            }

            // Create order items
            try (PreparedStatement stmt = conn.prepareStatement(CREATE_ORDER_ITEM_QUERY)) {
                for (OrderItem item : order.getItems()) {
                    stmt.setInt(1, order.getId());
                    stmt.setInt(2, item.getMenuItemId());
                    stmt.setInt(3, item.getQuantity());
                    stmt.setDouble(4, item.getPrice());
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }

            conn.commit();
            logger.info("Created order with ID: {} and {} items", order.getId(), order.getItems().size());
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.error("Error rolling back transaction", ex);
                }
            }
            logger.error("Error creating order with items", e);
            throw new RestaurantException("Error creating order with items", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing connection", e);
                }
            }
        }
    }

    public List<Order> findByUserId(int userId) throws RestaurantException {
        String query = "SELECT * FROM orders WHERE user_id = ?";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding orders by user ID", e);
            throw new RestaurantException("Error finding orders by user ID", e);
        }
        return orders;
    }

    public List<Order> findByStatus(String status) throws RestaurantException {
        String query = "SELECT * FROM orders WHERE status = ?";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding orders by status", e);
            throw new RestaurantException("Error finding orders by status", e);
        }
        return orders;
    }

    public List<Order> findByDateRange(Date startDate, Date endDate) throws RestaurantException {
        String query = "SELECT * FROM orders WHERE created_at BETWEEN ? AND ?";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding orders by date range", e);
            throw new RestaurantException("Error finding orders by date range", e);
        }
        return orders;
    }
} 