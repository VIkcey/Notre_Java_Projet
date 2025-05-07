package com.example.restaurant.controller;

import com.example.restaurant.exception.RestaurantException;
import com.example.restaurant.model.Reservation;
import com.example.restaurant.service.ReservationService;
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

@WebServlet("/api/reservations/*")
public class ReservationServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ReservationServlet.class);
    private final ReservationService reservationService;
    private final ObjectMapper objectMapper;

    public ReservationServlet() {
        this.reservationService = new ReservationService();
        this.objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all reservations
                List<Reservation> reservations = reservationService.getAllReservations();
                sendJsonResponse(response, reservations);
            } else {
                // Get reservation by ID
                int id = Integer.parseInt(pathInfo.substring(1));
                Reservation reservation = reservationService.getReservation(id);
                if (reservation != null) {
                    sendJsonResponse(response, reservation);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Reservation not found");
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
        } catch (RestaurantException e) {
            logger.error("Error processing GET request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Create a new reservation
            Reservation reservation = objectMapper.readValue(request.getInputStream(), Reservation.class);
            Reservation createdReservation = reservationService.createReservation(reservation);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, createdReservation);
        } catch (RestaurantException e) {
            logger.error("Error processing POST request", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Reservation ID is required");
                return;
            }

            int id = Integer.parseInt(pathInfo.substring(1));
            Reservation reservation = objectMapper.readValue(request.getInputStream(), Reservation.class);
            reservation.setId(id);
            
            Reservation updatedReservation = reservationService.updateReservation(reservation);
            sendJsonResponse(response, updatedReservation);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
        } catch (RestaurantException e) {
            logger.error("Error processing PUT request", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Reservation ID is required");
                return;
            }

            int id = Integer.parseInt(pathInfo.substring(1));
            reservationService.deleteReservation(id);
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid reservation ID");
        } catch (RestaurantException e) {
            logger.error("Error processing DELETE request", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getOutputStream(), data);
    }
}
