package com.example.restaurant.model;

/**
 * Interface for items that can be ordered in the restaurant system.
 * This interface defines the contract for orderable items.
 */
public interface Orderable {
    /**
     * Gets the unique identifier of the orderable item.
     *
     * @return The item's ID
     */
    int getId();

    /**
     * Gets the name of the orderable item.
     *
     * @return The item's name
     */
    String getName();

    /**
     * Gets the price of the orderable item.
     *
     * @return The item's price
     */
    double getPrice();

    /**
     * Gets the category of the orderable item.
     *
     * @return The item's category
     */
    String getCategory();
} 