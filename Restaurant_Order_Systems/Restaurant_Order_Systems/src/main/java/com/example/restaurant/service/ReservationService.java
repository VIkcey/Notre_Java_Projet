package com.example.restaurant.service;

import com.example.restaurant.dao.ReservationDAO;
import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.Reservation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Service class for handling reservation business logic.
 * Provides validation and business rules for reservations.
 */
public class ReservationService {
    private static final Logger logger = LoggerFactory.getLogger(ReservationService.class);
    private final ReservationDAO reservationDAO;

    public ReservationService() {
        this.reservationDAO = new ReservationDAO();
    }

    /**
     * Creates a new reservation with validation.
     *
     * @param reservation The reservation to create
     * @return The created reservation
     * @throws RestaurantException if validation fails or database error occurs
     */
    public Reservation createReservation(Reservation reservation) throws RestaurantException {
        validateReservation(reservation);
        return reservationDAO.create(reservation);
    }

    /**
     * Retrieves a reservation by ID.
     *
     * @param id The ID of the reservation
     * @return The reservation, or null if not found
     * @throws RestaurantException if database error occurs
     */
    public Reservation getReservation(int id) throws RestaurantException {
        return reservationDAO.findById(id);
    }

    /**
     * Retrieves all reservations.
     *
     * @return List of all reservations
     * @throws RestaurantException if database error occurs
     */
    public List<Reservation> getAllReservations() throws RestaurantException {
        return reservationDAO.findAll();
    }

    /**
     * Updates an existing reservation with validation.
     *
     * @param reservation The reservation to update
     * @return The updated reservation
     * @throws RestaurantException if validation fails or database error occurs
     */
    public Reservation updateReservation(Reservation reservation) throws RestaurantException {
        validateReservation(reservation);
        if (reservationDAO.findById(reservation.getId()) == null) {
            throw new RestaurantException("Reservation not found with ID: " + reservation.getId());
        }
        return reservationDAO.update(reservation);
    }

    /**
     * Deletes a reservation.
     *
     * @param id The ID of the reservation to delete
     * @throws RestaurantException if database error occurs
     */
    public void deleteReservation(int id) throws RestaurantException {
        if (reservationDAO.findById(id) == null) {
            throw new RestaurantException("Reservation not found with ID: " + id);
        }
        reservationDAO.delete(id);
    }

    /**
     * Validates a reservation.
     *
     * @param reservation The reservation to validate
     * @throws RestaurantException if validation fails
     */
    private void validateReservation(Reservation reservation) throws RestaurantException {
        if (reservation == null) {
            throw new RestaurantException("Reservation cannot be null");
        }
        if (reservation.getUserId() <= 0) {
            throw new RestaurantException("Invalid user ID");
        }
        if (reservation.getTableNumber() <= 0) {
            throw new RestaurantException("Invalid table number");
        }
        if (reservation.getPartySize() <= 0) {
            throw new RestaurantException("Party size must be greater than 0");
        }
        if (reservation.getReservationDate() == null) {
            throw new RestaurantException("Reservation date is required");
        }
        if (reservation.getStatus() == null || reservation.getStatus().trim().isEmpty()) {
            throw new RestaurantException("Reservation status is required");
        }
    }
} 