package com.example.restaurant.dao;

import com.example.restaurant.exception.RestaurantException;
import java.util.List;

/**
 * Base interface for Data Access Objects (DAOs).
 * Defines the basic CRUD operations that all DAOs should implement.
 *
 * @param <T> The type of entity this DAO handles
 * @param <ID> The type of the entity's primary key
 */
public interface BaseDAO<T, ID> {
    /**
     * Creates a new entity in the database.
     *
     * @param entity The entity to create
     * @return The created entity with its ID set
     * @throws RestaurantException if an error occurs during creation
     */
    T create(T entity) throws RestaurantException;

    /**
     * Retrieves an entity by its ID.
     *
     * @param id The ID of the entity to find
     * @return The found entity, or null if not found
     * @throws RestaurantException if an error occurs during retrieval
     */
    T findById(ID id) throws RestaurantException;

    /**
     * Retrieves all entities of type T.
     *
     * @return A list of all entities
     * @throws RestaurantException if an error occurs during retrieval
     */
    List<T> findAll() throws RestaurantException;

    /**
     * Updates an existing entity in the database.
     *
     * @param entity The entity to update
     * @return The updated entity
     * @throws RestaurantException if an error occurs during update
     */
    T update(T entity) throws RestaurantException;

    /**
     * Deletes an entity from the database.
     *
     * @param id The ID of the entity to delete
     * @throws RestaurantException if an error occurs during deletion
     */
    void delete(ID id) throws RestaurantException;
} 