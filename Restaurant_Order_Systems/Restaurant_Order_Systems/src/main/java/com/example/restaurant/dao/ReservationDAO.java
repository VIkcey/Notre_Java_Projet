package com.example.restaurant.dao;

import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.Reservation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Reservation entities.
 * Handles all database operations related to reservations.
 */
public class ReservationDAO extends AbstractBaseDAO<Reservation, Integer> {
    private static final Logger logger = LoggerFactory.getLogger(ReservationDAO.class);

    private static final String CREATE_QUERY = 
        "INSERT INTO reservations (user_id, table_number, reservation_date, party_size, status) VALUES (?, ?, ?, ?, ?)";
    private static final String FIND_BY_ID_QUERY = 
        "SELECT * FROM reservations WHERE id = ?";
    private static final String FIND_ALL_QUERY = 
        "SELECT * FROM reservations";
    private static final String UPDATE_QUERY = 
        "UPDATE reservations SET user_id = ?, table_number = ?, reservation_date = ?, party_size = ?, status = ? WHERE id = ?";
    private static final String DELETE_QUERY = 
        "DELETE FROM reservations WHERE id = ?";

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
    protected void setCreateParameters(PreparedStatement stmt, Reservation reservation) throws SQLException {
        stmt.setInt(1, reservation.getUserId());
        stmt.setInt(2, reservation.getTableNumber());
        stmt.setTimestamp(3, new Timestamp(reservation.getReservationDate().getTime()));
        stmt.setInt(4, reservation.getPartySize());
        stmt.setString(5, reservation.getStatus());
    }

    @Override
    protected void setUpdateParameters(PreparedStatement stmt, Reservation reservation) throws SQLException {
        stmt.setInt(1, reservation.getUserId());
        stmt.setInt(2, reservation.getTableNumber());
        stmt.setTimestamp(3, new Timestamp(reservation.getReservationDate().getTime()));
        stmt.setInt(4, reservation.getPartySize());
        stmt.setString(5, reservation.getStatus());
        stmt.setInt(6, reservation.getId());
    }

    @Override
    protected Reservation mapResultSetToEntity(ResultSet rs) throws SQLException {
        Reservation reservation = new Reservation();
        reservation.setId(rs.getInt("id"));
        reservation.setUserId(rs.getInt("user_id"));
        reservation.setTableNumber(rs.getInt("table_number"));
        reservation.setReservationDate(rs.getTimestamp("reservation_date"));
        reservation.setPartySize(rs.getInt("party_size"));
        reservation.setStatus(rs.getString("status"));
        return reservation;
    }

    public List<Reservation> findByUserId(int userId) throws RestaurantException {
        String query = "SELECT * FROM reservations WHERE user_id = ?";
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding reservations by user ID", e);
            throw new RestaurantException("Error finding reservations by user ID", e);
        }
        return reservations;
    }

    public List<Reservation> findByStatus(String status) throws RestaurantException {
        String query = "SELECT * FROM reservations WHERE status = ?";
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding reservations by status", e);
            throw new RestaurantException("Error finding reservations by status", e);
        }
        return reservations;
    }

    public List<Reservation> findByDateRange(Date startDate, Date endDate) throws RestaurantException {
        String query = "SELECT * FROM reservations WHERE reservation_date BETWEEN ? AND ?";
        List<Reservation> reservations = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            logger.error("Error finding reservations by date range", e);
            throw new RestaurantException("Error finding reservations by date range", e);
        }
        return reservations;
    }
} 