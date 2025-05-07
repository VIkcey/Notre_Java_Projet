package com.example.restaurant.dao;

import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.User;
import com.example.restaurant.util.DatabaseConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Abstract base implementation of the BaseDAO interface.
 * Provides common CRUD operations for all entities.
 *
 * @param <T> The type of entity this DAO handles
 * @param <ID> The type of the entity's primary key
 */
public abstract class AbstractBaseDAO<T, ID> implements BaseDAO<T, ID> {
    private static final Logger logger = LoggerFactory.getLogger(AbstractBaseDAO.class);
    protected final DatabaseConfig dbConfig;

    protected AbstractBaseDAO() {
        this.dbConfig = DatabaseConfig.getInstance();
    }

    protected Connection getConnection() throws SQLException {
        return dbConfig.getConnection();
    }

    /**
     * Gets the SQL query for creating a new entity.
     *
     * @return The SQL insert query
     */
    protected abstract String getCreateQuery();

    /**
     * Gets the SQL query for finding an entity by ID.
     *
     * @return The SQL select query
     */
    protected abstract String getFindByIdQuery();

    /**
     * Gets the SQL query for finding all entities.
     *
     * @return The SQL select query
     */
    protected abstract String getFindAllQuery();

    /**
     * Gets the SQL query for updating an entity.
     *
     * @return The SQL update query
     */
    protected abstract String getUpdateQuery();

    /**
     * Gets the SQL query for deleting an entity.
     *
     * @return The SQL delete query
     */
    protected abstract String getDeleteQuery();

    /**
     * Sets the parameters for the create statement.
     *
     * @param stmt The prepared statement
     * @param entity The entity to create
     * @throws SQLException if a database access error occurs
     */
    protected abstract void setCreateParameters(PreparedStatement stmt, T entity) throws SQLException;

    /**
     * Sets the parameters for the update statement.
     *
     * @param stmt The prepared statement
     * @param entity The entity to update
     * @throws SQLException if a database access error occurs
     */
    protected abstract void setUpdateParameters(PreparedStatement stmt, T entity) throws SQLException;

    /**
     * Maps a ResultSet row to an entity.
     *
     * @param rs The ResultSet containing the row data
     * @return The mapped entity
     * @throws SQLException if a database access error occurs
     */
    protected abstract T mapResultSetToEntity(ResultSet rs) throws SQLException;

    @Override
    public T create(T entity) throws RestaurantException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getCreateQuery(), new String[]{"id"})) {
            setCreateParameters(stmt, entity);
            stmt.executeUpdate();
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    if (entity instanceof User) {
                        ((User) entity).setId(generatedKeys.getInt(1));
                    }
                }
            }
            return entity;
        } catch (SQLException e) {
            logger.error("Error creating entity", e);
            throw new RestaurantException("Error creating entity", e);
        }
    }

    @Override
    public T findById(ID id) throws RestaurantException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getFindByIdQuery())) {
            stmt.setObject(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding entity by ID", e);
            throw new RestaurantException("Error finding entity by ID", e);
        }
        return null;
    }

    @Override
    public List<T> findAll() throws RestaurantException {
        List<T> entities = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getFindAllQuery());
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                entities.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            logger.error("Error finding all entities", e);
            throw new RestaurantException("Error finding all entities", e);
        }
        return entities;
    }

    @Override
    public T update(T entity) throws RestaurantException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getUpdateQuery())) {
            setUpdateParameters(stmt, entity);
            stmt.executeUpdate();
            return entity;
        } catch (SQLException e) {
            logger.error("Error updating entity", e);
            throw new RestaurantException("Error updating entity", e);
        }
    }

    @Override
    public void delete(ID id) throws RestaurantException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(getDeleteQuery())) {
            stmt.setObject(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("Error deleting entity", e);
            throw new RestaurantException("Error deleting entity", e);
        }
    }
} 