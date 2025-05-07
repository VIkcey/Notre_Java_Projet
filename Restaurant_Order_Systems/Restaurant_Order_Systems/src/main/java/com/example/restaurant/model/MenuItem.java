package com.example.restaurant.model;

/**
 * Represents a menu item in the restaurant system.
 * This class implements the Orderable interface to provide order functionality.
 */
public class MenuItem implements Orderable {
    private int id;
    private String name;
    private String description;
    private double price;
    private String category;
    private String status;

    /**
     * Constructs a new MenuItem with the specified details.
     *
     * @param id The unique identifier for the menu item
     * @param name The name of the menu item
     * @param description The description of the menu item
     * @param price The price of the menu item
     * @param category The category of the menu item
     * @param status The status of the menu item
     */
    public MenuItem(int id, String name, String description, double price, String category, String status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category = category;
        this.status = status;
    }
    public MenuItem(int id, String name, double price, String category) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
    }


    // Default constructor
    public MenuItem() {}

    @Override
    public int getId() { return id; }

    @Override
    public String getName() { return name; }

    public String getDescription() { return description; }

    @Override
    public double getPrice() { return price; }

    @Override
    public String getCategory() { return category; }

    public String getStatus() { return status; }

    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setDescription(String description) { this.description = description; }
    public void setPrice(double price) { this.price = price; }
    public void setCategory(String category) { this.category = category; }
    public void setStatus(String status) { this.status = status; }
}
