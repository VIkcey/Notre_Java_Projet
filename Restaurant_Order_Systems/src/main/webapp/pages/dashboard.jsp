<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Dashboard</title>
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
        .stat-card {
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background-color: white;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        .stat-card i {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        .stat-card h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        .stat-card p {
            color: #6c757d;
            margin-bottom: 0;
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
                        <a class="nav-link active" href="dashboard.jsp">
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
                        <a class="nav-link" href="reservations.jsp">
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
                <h2 class="mb-4">Dashboard Overview</h2>
                
                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-3">
                        <div class="stat-card">
                            <i class="fas fa-utensils text-primary"></i>
                            <h3>150</h3>
                            <p>Total Menu Items</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <i class="fas fa-shopping-cart text-success"></i>
                            <h3>25</h3>
                            <p>Active Orders</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <i class="fas fa-calendar-check text-info"></i>
                            <h3>12</h3>
                            <p>Today's Reservations</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card">
                            <i class="fas fa-users text-warning"></i>
                            <h3>1,250</h3>
                            <p>Total Customers</p>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Recent Orders</h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group">
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Order #1234</h6>
                                            <small>3 mins ago</small>
                                        </div>
                                        <p class="mb-1">2x Pizza, 1x Pasta</p>
                                        <small class="text-muted">$45.00</small>
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Order #1233</h6>
                                            <small>15 mins ago</small>
                                        </div>
                                        <p class="mb-1">1x Burger, 2x Fries</p>
                                        <small class="text-muted">$28.50</small>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Upcoming Reservations</h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group">
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Table #5</h6>
                                            <small>In 30 mins</small>
                                        </div>
                                        <p class="mb-1">John Doe - Party of 4</p>
                                        <small class="text-muted">7:00 PM</small>
                                    </a>
                                    <a href="#" class="list-group-item list-group-item-action">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Table #3</h6>
                                            <small>In 1 hour</small>
                                        </div>
                                        <p class="mb-1">Jane Smith - Party of 2</p>
                                        <small class="text-muted">7:30 PM</small>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
