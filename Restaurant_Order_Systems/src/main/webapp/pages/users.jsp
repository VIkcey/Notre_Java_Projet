<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Restaurant System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            padding-top: 20px;
        }
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 10px 20px;
            display: block;
        }
        .sidebar a:hover {
            background-color: #495057;
        }
        .sidebar a.active {
            background-color: #0d6efd;
        }
        .main-content {
            padding: 20px;
        }
        .user-card {
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .user-card:hover {
            transform: translateY(-5px);
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
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
                <a href="menu-management.jsp"><i class="fas fa-utensils me-2"></i> Menu Management</a>
                <a href="view-menu.jsp"><i class="fas fa-list me-2"></i> View Menu</a>
                <a href="orders.jsp"><i class="fas fa-shopping-cart me-2"></i> Orders</a>
                <a href="reservations.jsp"><i class="fas fa-calendar-alt me-2"></i> Reservations</a>
                <a href="users.jsp" class="active"><i class="fas fa-users me-2"></i> Users</a>
                <a href="reports.jsp"><i class="fas fa-chart-bar me-2"></i> Reports</a>
                <a href="settings.jsp"><i class="fas fa-cog me-2"></i> Settings</a>
                <a href="logout.jsp"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>User Management</h2>
                    <button class="btn btn-primary" onclick="showNewUserModal()">
                        <i class="fas fa-plus"></i> New User
                    </button>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <div class="row">
                        <div class="col-md-3">
                            <select class="form-select" id="roleFilter">
                                <option value="">All Roles</option>
                                <option value="ADMIN">Admin</option>
                                <option value="STAFF">Staff</option>
                                <option value="CUSTOMER">Customer</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="statusFilter">
                                <option value="">All Statuses</option>
                                <option value="ACTIVE">Active</option>
                                <option value="INACTIVE">Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" class="form-control" id="searchInput" placeholder="Search users...">
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-secondary w-100" onclick="applyFilters()">
                                <i class="fas fa-filter"></i> Apply Filters
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Users List -->
                <div class="row" id="usersList">
                    <c:forEach items="${users}" var="user">
                        <div class="col-md-6 col-lg-4">
                            <div class="card user-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h5 class="card-title">${user.username}</h5>
                                        <span class="badge ${user.status eq 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
                                            ${user.status}
                                        </span>
                                    </div>
                                    <p class="card-text">
                                        <i class="fas fa-envelope me-2"></i>${user.email}<br>
                                        <i class="fas fa-user-tag me-2"></i>${user.role}<br>
                                        <i class="fas fa-phone me-2"></i>${empty user.phone ? 'N/A' : user.phone}
                                    </p>
                                    <div class="d-flex justify-content-between">
                                        <button class="btn btn-sm btn-info" onclick="editUser(${user.id})">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteUser(${user.id})">
                                            <i class="fas fa-trash"></i> Delete
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

    <!-- New User Modal -->
    <div class="modal fade" id="newUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="newUserForm">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <select class="form-select" id="role" required>
                                <option value="CUSTOMER">Customer</option>
                                <option value="STAFF">Staff</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="tel" class="form-control" id="phone">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="createUser()">Create User</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editUserForm">
                        <input type="hidden" id="editUserId">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" id="editUsername" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" id="editEmail" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <select class="form-select" id="editRole" required>
                                <option value="CUSTOMER">Customer</option>
                                <option value="STAFF">Staff</option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="tel" class="form-control" id="editPhone">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" id="editStatus" required>
                                <option value="ACTIVE">Active</option>
                                <option value="INACTIVE">Inactive</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="updateUser()">Update User</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showNewUserModal() {
            const modal = new bootstrap.Modal(document.getElementById('newUserModal'));
            modal.show();
        }

        function createUser() {
            const user = {
                username: document.getElementById('username').value,
                email: document.getElementById('email').value,
                password: document.getElementById('password').value,
                role: document.getElementById('role').value,
                phone: document.getElementById('phone').value
            };

            fetch('/api/users', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
            .then(response => response.json())
            .then(result => {
                bootstrap.Modal.getInstance(document.getElementById('newUserModal')).hide();
                location.reload();
            })
            .catch(error => console.error('Error creating user:', error));
        }

        function editUser(userId) {
            fetch(`/api/users/${userId}`)
                .then(response => response.json())
                .then(user => {
                    document.getElementById('editUserId').value = user.id;
                    document.getElementById('editUsername').value = user.username;
                    document.getElementById('editEmail').value = user.email;
                    document.getElementById('editRole').value = user.role;
                    document.getElementById('editPhone').value = user.phone || '';
                    document.getElementById('editStatus').value = user.status;

                    const modal = new bootstrap.Modal(document.getElementById('editUserModal'));
                    modal.show();
                })
                .catch(error => console.error('Error loading user:', error));
        }

        function updateUser() {
            const userId = document.getElementById('editUserId').value;
            const user = {
                username: document.getElementById('editUsername').value,
                email: document.getElementById('editEmail').value,
                role: document.getElementById('editRole').value,
                phone: document.getElementById('editPhone').value,
                status: document.getElementById('editStatus').value
            };

            fetch(`/api/users/${userId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
            .then(response => response.json())
            .then(result => {
                bootstrap.Modal.getInstance(document.getElementById('editUserModal')).hide();
                location.reload();
            })
            .catch(error => console.error('Error updating user:', error));
        }

        function deleteUser(userId) {
            if (confirm('Are you sure you want to delete this user?')) {
                fetch(`/api/users/${userId}`, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    }
                })
                .catch(error => console.error('Error deleting user:', error));
            }
        }

        function applyFilters() {
            const role = document.getElementById('roleFilter').value;
            const status = document.getElementById('statusFilter').value;
            const search = document.getElementById('searchInput').value;

            let url = '/api/users?';
            if (role) url += `role=${role}&`;
            if (status) url += `status=${status}&`;
            if (search) url += `search=${search}`;

            fetch(url)
                .then(response => response.json())
                .then(users => {
                    const usersList = document.getElementById('usersList');
                    usersList.innerHTML = '';
                    users.forEach(user => {
                        const userCard = createUserCard(user);
                        usersList.appendChild(userCard);
                    });
                })
                .catch(error => console.error('Error applying filters:', error));
        }

        function createUserCard(user) {
            const div = document.createElement('div');
            div.className = 'col-md-6 col-lg-4';
            div.innerHTML = `
                <div class="card user-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="card-title">${user.username}</h5>
                            <span class="badge ${user.status == 'ACTIVE' ? 'bg-success' : 'bg-danger'}">
                                ${user.status}
                            </span>
                        </div>
                        <p class="card-text">
                            <i class="fas fa-envelope me-2"></i>${user.email}<br>
                            <i class="fas fa-user-tag me-2"></i>${user.role}<br>
                            <i class="fas fa-phone me-2"></i>${user.phone || 'N/A'}
                        </p>
                        <div class="d-flex justify-content-between">
                            <button class="btn btn-sm btn-info" onclick="editUser(${user.id})">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-sm btn-danger" onclick="deleteUser(${user.id})">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
            `;
            return div;
        }
    </script>
</body>
</html> 