<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - Restaurant System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar { min-height: 100vh; background-color: #343a40; padding-top: 20px; }
        .sidebar a { color: #fff; text-decoration: none; padding: 10px 20px; display: block; }
        .sidebar a:hover { background-color: #495057; }
        .sidebar a.active { background-color: #0d6efd; }
        .main-content { padding: 20px; }
        .order-card { margin-bottom: 20px; transition: transform 0.2s; }
        .order-card:hover { transform: translateY(-5px); }
        .status-badge { font-size: 0.9em; padding: 5px 10px; }
        .filter-section { background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .order-items-table {
            font-size: 0.9em;
        }
        .order-items-table th {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 sidebar">
            <h3 class="text-white text-center mb-4">Restaurant</h3>
            <a href="dashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
            <a href="customer-menu.jsp"><i class="fas fa-utensils me-2"></i> Menu Management</a>
            <a href="menu.jsp"><i class="fas fa-list me-2"></i> View Menu</a>
            <a href="orders.jsp" class="active"><i class="fas fa-shopping-cart me-2"></i> Orders</a>
            <a href="reservations.jsp"><i class="fas fa-calendar-alt me-2"></i> Reservations</a>
            <a href="users.jsp"><i class="fas fa-users me-2"></i> Users</a>
            <a href="reports.jsp"><i class="fas fa-chart-bar me-2"></i> Reports</a>
            <a href="settings.jsp"><i class="fas fa-cog me-2"></i> Settings</a>
            <a href="login.jsp"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Order Management</h2>
                <button class="btn btn-primary" onclick="showNewOrderModal()">
                    <i class="fas fa-plus"></i> New Order
                </button>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row">
                    <div class="col-md-3">
                        <select class="form-select" id="statusFilter">
                            <option value="">All Statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="CONFIRMED">Confirmed</option>
                            <option value="PREPARING">Preparing</option>
                            <option value="READY">Ready</option>
                            <option value="DELIVERED">Delivered</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <input type="date" class="form-control" id="dateFilter">
                    </div>
                    <div class="col-md-4">
                        <input type="text" class="form-control" id="searchInput" placeholder="Search orders...">
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-secondary w-100" onclick="applyFilters()">
                            <i class="fas fa-filter"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </div>

            <!-- Orders List -->
            <div class="row" id="ordersList">
                <c:forEach items="${orders}" var="order">
                    <div class="col-md-6 col-lg-4">
                        <div class="card order-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h5 class="card-title">Order #${order.id}</h5>
                                    <span class="badge ${order.status eq 'DELIVERED' ? 'bg-success' :
                                                     order.status eq 'CANCELLED' ? 'bg-danger' :
                                                     order.status eq 'PREPARING' ? 'bg-warning' : 'bg-info'}">
                                            ${order.status}
                                    </span>
                                </div>
                                <p class="card-text">
                                    <i class="fas fa-user me-2"></i>${order.customerName}<br>
                                    <i class="fas fa-clock me-2"></i><fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy HH:mm"/><br>
                                    <i class="fas fa-dollar-sign me-2"></i>${order.totalAmount}
                                </p>
                                <div class="d-flex justify-content-between">
                                    <button class="btn btn-sm btn-info" onclick="viewOrderDetails('${order.id}')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="btn btn-sm btn-primary" onclick="updateOrderStatus('${order.id}')">
                                        <i class="fas fa-edit"></i> Update Status
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- Order Details Modal -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Order Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong>Order ID:</strong> <span id="modalOrderId"></span></p>
                        <p><strong>Customer:</strong> <span id="modalCustomerName"></span></p>
                        <p><strong>Date:</strong> <span id="modalOrderDate"></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Status:</strong> <span id="modalOrderStatus"></span></p>
                        <p><strong>Total:</strong> $<span id="modalOrderTotal"></span></p>
                        <p><strong>Special Instructions:</strong> <span id="modalSpecialInstructions"></span></p>
                    </div>
                </div>
                <h6>Order Items</h6>
                <div class="table-responsive">
                    <table class="table table-sm order-items-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody id="modalOrderItems">
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="updateStatusBtn">Update Status</button>
            </div>
        </div>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Update Order Status</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="updateStatusForm">
                    <input type="hidden" id="updateOrderId">
                    <div class="mb-3">
                        <label for="newStatus" class="form-label">New Status</label>
                        <select class="form-select" id="newStatus" required>
                            <option value="PENDING">Pending</option>
                            <option value="PREPARING">Preparing</option>
                            <option value="READY">Ready</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveStatusBtn">Save Changes</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Global variables
    let orders = [];
    const orderDetailsModal = new bootstrap.Modal(document.getElementById('orderDetailsModal'));
    const updateStatusModal = new bootstrap.Modal(document.getElementById('updateStatusModal'));

    // Load orders on page load
    document.addEventListener('DOMContentLoaded', () => {
        loadOrders();
        setupEventListeners();
    });

    function setupEventListeners() {
        // Status filter change
        document.getElementById('statusFilter').addEventListener('change', loadOrders);
        
        // Date filter change
        document.getElementById('dateFilter').addEventListener('change', loadOrders);
        
        // Update status button click
        document.getElementById('updateStatusBtn').addEventListener('click', () => {
            const orderId = document.getElementById('modalOrderId').textContent;
            document.getElementById('updateOrderId').value = orderId;
            document.getElementById('newStatus').value = orders.find(o => o.id === parseInt(orderId)).status;
            updateStatusModal.show();
        });
        
        // Save status button click
        document.getElementById('saveStatusBtn').addEventListener('click', updateOrderStatus);
    }

    async function loadOrders() {
        try {
            const status = document.getElementById('statusFilter').value;
            const date = document.getElementById('dateFilter').value;
            
            let url = 'api/orders';
            const params = new URLSearchParams();
            if (status) params.append('status', status);
            if (date) params.append('date', date);
            if (params.toString()) url += '?' + params.toString();
            
            const response = await fetch(url);
            if (!response.ok) throw new Error('Failed to load orders');
            
            orders = await response.json();
            displayOrders(orders);
        } catch (error) {
            console.error('Error loading orders:', error);
            showToast('error', 'Failed to load orders');
        }
    }

    function displayOrders(orders) {
        // Implementation of displayOrders function
    }

    function showToast(type, message) {
        // Implementation of showToast function
    }
</script>
</body>
</html>