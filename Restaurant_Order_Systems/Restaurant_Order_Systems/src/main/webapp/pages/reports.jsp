<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports - Restaurant System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .report-card {
            margin-bottom: 1.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 1rem;
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
                        <a class="nav-link" href="reservations.jsp">
                            <i class="fas fa-calendar-alt"></i> Reservations
                        </a>
                        <a class="nav-link" href="users.jsp">
                            <i class="fas fa-users"></i> Users
                        </a>
                        <a class="nav-link active" href="reports.jsp">
                            <i class="fas fa-chart-bar"></i> Reports
                        </a>
                        <a class="nav-link" href="settings.jsp">
                            <i class="fas fa-cog"></i> Settings
                        </a>
                        <a class="nav-link" href="login.php">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Reports & Analytics</h2>
                    <div class="btn-group">
                        <button class="btn btn-outline-primary" onclick="exportReport('pdf')">
                            <i class="fas fa-file-pdf"></i> Export PDF
                        </button>
                        <button class="btn btn-outline-success" onclick="exportReport('excel')">
                            <i class="fas fa-file-excel"></i> Export Excel
                        </button>
                    </div>
                </div>

                <!-- Date Range Filter -->
                <div class="card report-card mb-4">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-4">
                                <label for="dateRange" class="form-label">Date Range</label>
                                <select class="form-select" id="dateRange" onchange="updateReports()">
                                    <option value="today">Today</option>
                                    <option value="week">This Week</option>
                                    <option value="month" selected>This Month</option>
                                    <option value="year">This Year</option>
                                    <option value="custom">Custom Range</option>
                                </select>
                            </div>
                            <div class="col-md-8" id="customDateRange" style="display: none;">
                                <div class="row">
                                    <div class="col-md-5">
                                        <label for="startDate" class="form-label">Start Date</label>
                                        <input type="date" class="form-control" id="startDate">
                                    </div>
                                    <div class="col-md-5">
                                        <label for="endDate" class="form-label">End Date</label>
                                        <input type="date" class="form-control" id="endDate">
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end">
                                        <button class="btn btn-primary w-100" onclick="updateReports()">Apply</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sales Overview -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card report-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Sales Overview</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="salesChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card report-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Top Selling Items</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="topItemsChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Additional Reports -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card report-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Reservation Statistics</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="reservationsChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card report-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Customer Demographics</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="demographicsChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize charts
        let salesChart, topItemsChart, reservationsChart, demographicsChart;

        // Load report data
        function loadReportData() {
            const dateRange = document.getElementById('dateRange').value;
            let startDate, endDate;

            if (dateRange === 'custom') {
                startDate = document.getElementById('startDate').value;
                endDate = document.getElementById('endDate').value;
            } else {
                const dates = getDateRange(dateRange);
                startDate = dates.start;
                endDate = dates.end;
            }

            // Load sales data
            fetch(`/api/reports/sales?startDate=${startDate}&endDate=${endDate}`)
                .then(response => response.json())
                .then(data => {
                    updateSalesChart(data);
                });

            // Load top items data
            fetch(`/api/reports/top-items?startDate=${startDate}&endDate=${endDate}`)
                .then(response => response.json())
                .then(data => {
                    updateTopItemsChart(data);
                });

            // Load reservations data
            fetch(`/api/reports/reservations?startDate=${startDate}&endDate=${endDate}`)
                .then(response => response.json())
                .then(data => {
                    updateReservationsChart(data);
                });

            // Load demographics data
            fetch(`/api/reports/demographics?startDate=${startDate}&endDate=${endDate}`)
                .then(response => response.json())
                .then(data => {
                    updateDemographicsChart(data);
                });
        }

        // Update sales chart
        function updateSalesChart(data) {
            const ctx = document.getElementById('salesChart').getContext('2d');
            if (salesChart) {
                salesChart.destroy();
            }
            salesChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'Sales',
                        data: data.values,
                        borderColor: 'rgb(75, 192, 192)',
                        tension: 0.1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        // Update top items chart
        function updateTopItemsChart(data) {
            const ctx = document.getElementById('topItemsChart').getContext('2d');
            if (topItemsChart) {
                topItemsChart.destroy();
            }
            topItemsChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: 'Units Sold',
                        data: data.values,
                        backgroundColor: 'rgba(54, 162, 235, 0.5)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        // Update reservations chart
        function updateReservationsChart(data) {
            const ctx = document.getElementById('reservationsChart').getContext('2d');
            if (reservationsChart) {
                reservationsChart.destroy();
            }
            reservationsChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: data.labels,
                    datasets: [{
                        data: data.values,
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.5)',
                            'rgba(255, 99, 132, 0.5)',
                            'rgba(255, 205, 86, 0.5)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        // Update demographics chart
        function updateDemographicsChart(data) {
            const ctx = document.getElementById('demographicsChart').getContext('2d');
            if (demographicsChart) {
                demographicsChart.destroy();
            }
            demographicsChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: data.labels,
                    datasets: [{
                        data: data.values,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.5)',
                            'rgba(54, 162, 235, 0.5)',
                            'rgba(255, 206, 86, 0.5)',
                            'rgba(75, 192, 192, 0.5)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        // Get date range based on selection
        function getDateRange(range) {
            const today = new Date();
            let start = new Date();
            let end = new Date();

            switch (range) {
                case 'today':
                    start.setHours(0, 0, 0, 0);
                    break;
                case 'week':
                    start.setDate(today.getDate() - today.getDay());
                    break;
                case 'month':
                    start.setDate(1);
                    break;
                case 'year':
                    start.setMonth(0, 1);
                    break;
            }

            return {
                start: start.toISOString().split('T')[0],
                end: end.toISOString().split('T')[0]
            };
        }

        // Handle date range selection
        document.getElementById('dateRange').addEventListener('change', function() {
            const customRange = document.getElementById('customDateRange');
            if (this.value === 'custom') {
                customRange.style.display = 'block';
            } else {
                customRange.style.display = 'none';
                updateReports();
            }
        });

        // Update reports
        function updateReports() {
            loadReportData();
        }

        // Export report
        function exportReport(format) {
            const dateRange = document.getElementById('dateRange').value;
            let startDate, endDate;

            if (dateRange === 'custom') {
                startDate = document.getElementById('startDate').value;
                endDate = document.getElementById('endDate').value;
            } else {
                const dates = getDateRange(dateRange);
                startDate = dates.start;
                endDate = dates.end;
            }

            window.location.href = `/api/reports/export?format=${format}&startDate=${startDate}&endDate=${endDate}`;
        }

        // Initialize reports when page loads
        document.addEventListener('DOMContentLoaded', loadReportData);
    </script>
</body>
</html> 