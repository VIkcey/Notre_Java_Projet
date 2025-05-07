<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - Restaurant System</title>
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
        .settings-card {
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .settings-card:hover {
            transform: translateY(-5px);
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
                <a href="users.jsp"><i class="fas fa-users me-2"></i> Users</a>
                <a href="reports.jsp"><i class="fas fa-chart-bar me-2"></i> Reports</a>
                <a href="settings.jsp" class="active"><i class="fas fa-cog me-2"></i> Settings</a>
                <a href="login.jsp"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>System Settings</h2>
                </div>

                <!-- Settings Sections -->
                <div class="row">
                    <!-- Restaurant Information -->
                    <div class="col-md-6">
                        <div class="card settings-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-store me-2"></i>Restaurant Information
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="restaurantInfoForm">
                                    <div class="mb-3">
                                        <label class="form-label">Restaurant Name</label>
                                        <input type="text" class="form-control" id="restaurantName" value="${settings.restaurantName}">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Address</label>
                                        <textarea class="form-control" id="address" rows="3">${settings.address}</textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Phone</label>
                                        <input type="tel" class="form-control" id="phone" value="${settings.phone}">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" value="${settings.email}">
                                    </div>
                                    <button type="button" class="btn btn-primary" onclick="updateRestaurantInfo()">
                                        <i class="fas fa-save me-2"></i>Save Changes
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Business Hours -->
                    <div class="col-md-6">
                        <div class="card settings-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-clock me-2"></i>Business Hours
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="businessHoursForm">
                                    <c:forEach items="${settings.businessHours}" var="day">
                                        <div class="mb-3">
                                            <label class="form-label">${day.name}</label>
                                            <div class="row">
                                                <div class="col">
                                                    <input type="time" class="form-control" 
                                                           id="open_${day.name}" 
                                                           value="${day.openTime}">
                                                </div>
                                                <div class="col">
                                                    <input type="time" class="form-control" 
                                                           id="close_${day.name}" 
                                                           value="${day.closeTime}">
                                                </div>
                                                <div class="col-auto">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" 
                                                               id="closed_${day.name}" 
                                                               ${day.closed ? 'checked' : ''}>
                                                        <label class="form-check-label">Closed</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <button type="button" class="btn btn-primary" onclick="updateBusinessHours()">
                                        <i class="fas fa-save me-2"></i>Save Changes
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- System Settings -->
                    <div class="col-md-6">
                        <div class="card settings-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-sliders-h me-2"></i>System Settings
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="systemSettingsForm">
                                    <div class="mb-3">
                                        <label class="form-label">Default Currency</label>
                                        <select class="form-select" id="currency">
                                            <option value="USD" ${settings.currency eq 'USD' ? 'selected' : ''}>USD ($)</option>
                                            <option value="EUR" ${settings.currency eq 'EUR' ? 'selected' : ''}>EUR (€)</option>
                                            <option value="GBP" ${settings.currency eq 'GBP' ? 'selected' : ''}>GBP (£)</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Time Zone</label>
                                        <select class="form-select" id="timezone">
                                            <option value="UTC" ${settings.timezone eq 'UTC' ? 'selected' : ''}>UTC</option>
                                            <option value="EST" ${settings.timezone eq 'EST' ? 'selected' : ''}>EST</option>
                                            <option value="PST" ${settings.timezone eq 'PST' ? 'selected' : ''}>PST</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Date Format</label>
                                        <select class="form-select" id="dateFormat">
                                            <option value="MM/dd/yyyy" ${settings.dateFormat eq 'MM/dd/yyyy' ? 'selected' : ''}>MM/DD/YYYY</option>
                                            <option value="dd/MM/yyyy" ${settings.dateFormat eq 'dd/MM/yyyy' ? 'selected' : ''}>DD/MM/YYYY</option>
                                            <option value="yyyy-MM-dd" ${settings.dateFormat eq 'yyyy-MM-dd' ? 'selected' : ''}>YYYY-MM-DD</option>
                                        </select>
                                    </div>
                                    <button type="button" class="btn btn-primary" onclick="updateSystemSettings()">
                                        <i class="fas fa-save me-2"></i>Save Changes
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Notification Settings -->
                    <div class="col-md-6">
                        <div class="card settings-card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-bell me-2"></i>Notification Settings
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="notificationSettingsForm">
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="emailNotifications" 
                                                   ${settings.emailNotifications ? 'checked' : ''}>
                                            <label class="form-check-label">Email Notifications</label>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="smsNotifications" 
                                                   ${settings.smsNotifications ? 'checked' : ''}>
                                            <label class="form-check-label">SMS Notifications</label>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Notification Email</label>
                                        <input type="email" class="form-control" id="notificationEmail" 
                                               value="${settings.notificationEmail}">
                                    </div>
                                    <button type="button" class="btn btn-primary" onclick="updateNotificationSettings()">
                                        <i class="fas fa-save me-2"></i>Save Changes
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateRestaurantInfo() {
            const data = {
                restaurantName: document.getElementById('restaurantName').value,
                address: document.getElementById('address').value,
                phone: document.getElementById('phone').value,
                email: document.getElementById('email').value
            };

            fetch('/api/settings/restaurant', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                showToast('Restaurant information updated successfully');
            })
            .catch(error => {
                console.error('Error updating restaurant info:', error);
                showToast('Failed to update restaurant information', 'error');
            });
        }

        function updateBusinessHours() {
            const businessHours = {};
            const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
            
            days.forEach(day => {
                businessHours[day] = {
                    openTime: document.getElementById(`open_${day}`).value,
                    closeTime: document.getElementById(`close_${day}`).value,
                    closed: document.getElementById(`closed_${day}`).checked
                };
            });

            fetch('/api/settings/business-hours', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(businessHours)
            })
            .then(response => response.json())
            .then(result => {
                showToast('Business hours updated successfully');
            })
            .catch(error => {
                console.error('Error updating business hours:', error);
                showToast('Failed to update business hours', 'error');
            });
        }

        function updateSystemSettings() {
            const data = {
                currency: document.getElementById('currency').value,
                timezone: document.getElementById('timezone').value,
                dateFormat: document.getElementById('dateFormat').value
            };

            fetch('/api/settings/system', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                showToast('System settings updated successfully');
            })
            .catch(error => {
                console.error('Error updating system settings:', error);
                showToast('Failed to update system settings', 'error');
            });
        }

        function updateNotificationSettings() {
            const data = {
                emailNotifications: document.getElementById('emailNotifications').checked,
                smsNotifications: document.getElementById('smsNotifications').checked,
                notificationEmail: document.getElementById('notificationEmail').value
            };

            fetch('/api/settings/notifications', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                showToast('Notification settings updated successfully');
            })
            .catch(error => {
                console.error('Error updating notification settings:', error);
                showToast('Failed to update notification settings', 'error');
            });
        }

        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = 'position-fixed bottom-0 end-0 p-3';
            toast.style.zIndex = '5';
            toast.innerHTML = `
                <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <strong class="me-auto">${type == 'success' ? 'Success' : 'Error'}</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${message}
                    </div>
                </div>
            `;
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }
    </script>
</body>
</html> 