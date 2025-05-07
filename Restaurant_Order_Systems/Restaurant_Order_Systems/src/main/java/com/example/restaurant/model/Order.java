package com.example.restaurant.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Represents an order in the restaurant system.
 */
public class Order {
    private int id;
    private int userId;
    private double total;
    private String status;
    private Date createdAt;
    private String specialInstructions; // ✅ ADDED
    private List<OrderItem> items;

    // Default constructor
    public Order() {
        this(0, 0, 0.0, "Pending");
    }

    // Parameterized constructor
    public Order(int id, int userId, double total, String status) {
        this.id = id;
        this.userId = userId;
        this.total = total;
        this.status = status;
        this.items = new ArrayList<>();
        this.createdAt = new Date(); // Set current date/time
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getSpecialInstructions() { return specialInstructions; } // ✅ ADDED
    public void setSpecialInstructions(String specialInstructions) { this.specialInstructions = specialInstructions; } // ✅ ADDED

    public List<OrderItem> getItems() { return items; }

    public void setItems(List<OrderItem> items) {
        this.items = (items != null) ? items : new ArrayList<>();
        recalculateTotal(); // Recalculate total if items replaced
    }

    // Add a single item to the order and update total
    public void addItem(OrderItem item) {
        if (item != null) {
            this.items.add(item);
            this.total += item.getPrice() * item.getQuantity();
        }
    }

    // Remove item and update total
    public void removeItem(OrderItem item) {
        if (item != null && this.items.remove(item)) {
            this.total -= item.getPrice() * item.getQuantity();
        }
    }

    // Recalculate total from all order items
    private void recalculateTotal() {
        this.total = 0;
        for (OrderItem item : this.items) {
            this.total += item.getPrice() * item.getQuantity();
        }
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", total=" + total +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", specialInstructions='" + specialInstructions + '\'' + // ✅ ADDED
                ", items=" + items +
                '}';
    }
}
