<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Menu Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .menu-item-card {
            margin-bottom: 1rem;
        }
        .category-header {
            margin-top: 2rem;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #dee2e6;
        }
        .error-message {
            color: red;
            margin: 10px 0;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1>Restaurant Menu Management</h1>
        
        <!-- Error Message -->
        <div id="errorMessage" class="error-message alert alert-danger"></div>
        
        <!-- Add Menu Item Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0">Add New Menu Item</h5>
            </div>
            <div class="card-body">
                <form id="addMenuItemForm">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="name" class="form-label">Name</label>
                                <input type="text" class="form-control" id="name" required>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="mb-3">
                                <label for="price" class="form-label">Price</label>
                                <input type="number" class="form-control" id="price" step="0.01" required>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="mb-3">
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" required>
                                    <option value="">Select Category</option>
                                    <option value="Appetizers">Appetizers</option>
                                    <option value="Main Course">Main Course</option>
                                    <option value="Desserts">Desserts</option>
                                    <option value="Beverages">Beverages</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="mb-3">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary w-100">Add Item</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Menu Items Display -->
        <div id="menuItems">
            <!-- Items will be loaded here dynamically -->
        </div>
    </div>

    <!-- Edit Menu Item Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Menu Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="editMenuItemForm">
                        <input type="hidden" id="editId">
                        <div class="mb-3">
                            <label for="editName" class="form-label">Name</label>
                            <input type="text" class="form-control" id="editName" required>
                        </div>
                        <div class="mb-3">
                            <label for="editPrice" class="form-label">Price</label>
                            <input type="number" class="form-control" id="editPrice" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="editCategory" class="form-label">Category</label>
                            <select class="form-select" id="editCategory" required>
                                <option value="Appetizers">Appetizers</option>
                                <option value="Main Course">Main Course</option>
                                <option value="Desserts">Desserts</option>
                                <option value="Beverages">Beverages</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveEdit">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Show error message
        function showError(message) {
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            setTimeout(() => {
                errorDiv.style.display = 'none';
            }, 5000);
        }

        // Load menu items
        function loadMenuItems() {
            fetch('/api/menu-items')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to load menu items');
                    }
                    return response.json();
                })
                .then(items => {
                    const menuItemsDiv = document.getElementById('menuItems');
                    menuItemsDiv.innerHTML = '';
                    
                    if (items.length === 0) {
                        menuItemsDiv.innerHTML = '<div class="alert alert-info">No menu items found.</div>';
                        return;
                    }
                    
                    // Group items by category
                    const categories = {};
                    items.forEach(item => {
                        if (!categories[item.category]) {
                            categories[item.category] = [];
                        }
                        categories[item.category].push(item);
                    });

                    // Display items by category
                    Object.keys(categories).sort().forEach(category => {
                        const categoryDiv = document.createElement('div');
                        categoryDiv.innerHTML = `
                            <h3 class="category-header">${category}</h3>
                            <div class="row" id="category-${category}"></div>
                        `;
                        menuItemsDiv.appendChild(categoryDiv);

                        const categoryItemsDiv = document.getElementById(`category-${category}`);
                        categories[category].forEach(item => {
                            const itemCard = document.createElement('div');
                            itemCard.className = 'col-md-4';
                            itemCard.innerHTML = `
                                <div class="card menu-item-card">
                                    <div class="card-body">
                                        <h5 class="card-title">${item.name}</h5>
                                        <p class="card-text">$${item.price.toFixed(2)}</p>
                                        <button class="btn btn-sm btn-primary edit-item" data-id="${item.id}">Edit</button>
                                        <button class="btn btn-sm btn-danger delete-item" data-id="${item.id}">Delete</button>
                                    </div>
                                </div>
                            `;
                            categoryItemsDiv.appendChild(itemCard);
                        });
                    });

                    // Add event listeners
                    document.querySelectorAll('.edit-item').forEach(button => {
                        button.addEventListener('click', () => showEditModal(button.dataset.id));
                    });
                    document.querySelectorAll('.delete-item').forEach(button => {
                        button.addEventListener('click', () => deleteMenuItem(button.dataset.id));
                    });
                })
                .catch(error => {
                    console.error('Error loading menu items:', error);
                    showError('Failed to load menu items. Please try again later.');
                });
        }

        // Add new menu item
        document.getElementById('addMenuItemForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const menuItem = {
                name: document.getElementById('name').value,
                price: parseFloat(document.getElementById('price').value),
                category: document.getElementById('category').value,
                status: 'ACTIVE'
            };

            fetch('/api/menu-items', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(menuItem)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to add menu item');
                }
                this.reset();
                loadMenuItems();
            })
            .catch(error => {
                console.error('Error adding menu item:', error);
                showError('Failed to add menu item. Please try again.');
            });
        });

        // Show edit modal
        function showEditModal(id) {
            fetch(`/api/menu-items/${id}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to load menu item');
                    }
                    return response.json();
                })
                .then(item => {
                    document.getElementById('editId').value = item.id;
                    document.getElementById('editName').value = item.name;
                    document.getElementById('editPrice').value = item.price;
                    document.getElementById('editCategory').value = item.category;
                    new bootstrap.Modal(document.getElementById('editModal')).show();
                })
                .catch(error => {
                    console.error('Error loading menu item:', error);
                    showError('Failed to load menu item. Please try again.');
                });
        }

        // Save edited menu item
        document.getElementById('saveEdit').addEventListener('click', function() {
            const id = document.getElementById('editId').value;
            const menuItem = {
                id: parseInt(id),
                name: document.getElementById('editName').value,
                price: parseFloat(document.getElementById('editPrice').value),
                category: document.getElementById('editCategory').value,
                status: 'ACTIVE'
            };

            fetch(`/api/menu-items/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(menuItem)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to update menu item');
                }
                bootstrap.Modal.getInstance(document.getElementById('editModal')).hide();
                loadMenuItems();
            })
            .catch(error => {
                console.error('Error updating menu item:', error);
                showError('Failed to update menu item. Please try again.');
            });
        });

        // Delete menu item
        function deleteMenuItem(id) {
            if (confirm('Are you sure you want to delete this menu item?')) {
                fetch(`/api/menu-items/${id}`, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Failed to delete menu item');
                    }
                    loadMenuItems();
                })
                .catch(error => {
                    console.error('Error deleting menu item:', error);
                    showError('Failed to delete menu item. Please try again.');
                });
            }
        }

        // Load menu items when page loads
        document.addEventListener('DOMContentLoaded', loadMenuItems);
    </script>
</body>
</html>
