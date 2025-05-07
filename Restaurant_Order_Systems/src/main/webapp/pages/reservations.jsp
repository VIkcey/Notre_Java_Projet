<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reservations - Restaurant System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #2c3e50;
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,.8);
            padding: 1rem;
            margin: 0.2rem 0;
            border-radius: 0.25rem;
        }
        .sidebar .nav-link:hover {
            color: white;
            background-color: rgba(255,255,255,.1);
        }
        .sidebar .nav-link.active {
            color: white;
            background-color: rgba(255,255,255,.2);
        }
        .sidebar .nav-link i {
            margin-right: 0.5rem;
        }
        .main-content {
            padding: 2rem;
        }
        .reservation-card {
            transition: transform 0.2s;
        }
        .reservation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 px-0 sidebar">
            <div class="p-3">
                <h4 class="text-center mb-4">Restaurant Admin</h4>
                <nav class="nav flex-column">
                    <a class="nav-link" href="dashboard.jsp">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                    <a class="nav-link" href="menu.jsp">
                        <i class="fas fa-utensils"></i> Menu Management
                    </a>
                    <a class="nav-link" href="customer-menu.jsp">
                        <i class="fas fa-book-open"></i> View Menu
                    </a>
                    <a class="nav-link" href="orders.jsp">
                        <i class="fas fa-shopping-cart"></i> Orders
                    </a>
                    <a class="nav-link active" href="reservations.jsp">
                        <i class="fas fa-calendar-alt"></i> Reservations
                    </a>
                    <a class="nav-link" href="users.jsp">
                        <i class="fas fa-users"></i> Users
                    </a>
                    <a class="nav-link" href="reports.jsp">
                        <i class="fas fa-chart-bar"></i> Reports
                    </a>
                    <a class="nav-link" href="settings.jsp">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                    <a class="nav-link" href="login.jsp">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Reservations</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#newReservationModal">
                    <i class="fas fa-plus"></i> New Reservation
                </button>
            </div>

            <!-- Reservations List -->
            <div class="row" id="reservationsList">
                <!-- Reservations will be loaded here dynamically -->
            </div>
        </div>
    </div>
</div>

<!-- New Reservation Modal -->
<div class="modal fade" id="newReservationModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Make a Reservation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="reservationForm">
                    <div class="mb-3">
                        <label for="reservationDate" class="form-label">Date</label>
                        <input type="date" class="form-control" id="reservationDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="reservationTime" class="form-label">Time</label>
                        <input type="time" class="form-control" id="reservationTime" required>
                    </div>
                    <div class="mb-3">
                        <label for="partySize" class="form-label">Party Size</label>
                        <input type="number" class="form-control" id="partySize" min="1" max="20" required>
                    </div>
                    <div class="mb-3">
                        <label for="tableNumber" class="form-label">Table Number</label>
                        <select class="form-select" id="tableNumber" required>
                            <!-- Tables will be loaded dynamically -->
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="specialRequests" class="form-label">Special Requests</label>
                        <textarea class="form-control" id="specialRequests" rows="3"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="submitReservation()">Make Reservation</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        loadReservations();
        loadAvailableTables();
    });
</script>
</body>
</html>
