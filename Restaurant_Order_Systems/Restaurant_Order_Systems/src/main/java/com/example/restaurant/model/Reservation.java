package com.example.restaurant.model;

import java.util.Date;

/**
 * Model class representing a restaurant reservation.
 */
public class Reservation {
    private int id;
    private int userId;
    private int tableNumber;
    private Date reservationDate;
    private int partySize;
    private String status;

    // Default constructor
    public Reservation() {
        this.status = "PENDING";
    }

    // Parameterized constructor (optional)
    public Reservation(int id, int userId, int tableNumber, Date reservationDate, int partySize, String status) {
        this.id = id;
        this.userId = userId;
        this.tableNumber = tableNumber;
        this.reservationDate = reservationDate;
        this.partySize = partySize;
        this.status = status != null ? status : "PENDING";
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTableNumber() { return tableNumber; }
    public void setTableNumber(int tableNumber) { this.tableNumber = tableNumber; }

    public Date getReservationDate() { return reservationDate; }
    public void setReservationDate(Date reservationDate) { this.reservationDate = reservationDate; }

    public int getPartySize() { return partySize; }
    public void setPartySize(int partySize) { this.partySize = partySize; }

    public String getStatus() { return status; }
    public void setStatus(String status) {
        this.status = (status != null && !status.isBlank()) ? status : "PENDING";
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "id=" + id +
                ", userId=" + userId +
                ", tableNumber=" + tableNumber +
                ", reservationDate=" + reservationDate +
                ", partySize=" + partySize +
                ", status='" + status + '\'' +
                '}';
    }
}
