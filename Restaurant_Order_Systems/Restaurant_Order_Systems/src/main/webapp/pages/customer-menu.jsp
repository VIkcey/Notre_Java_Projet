<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Menu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .menu-item-card {
            margin-bottom: 1rem;
            transition: transform 0.2s;
            height: 100%;
        }
        .menu-item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .category-header {
            margin-top: 2rem;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #dee2e6;
            color: #2c3e50;
        }
        .cart-badge {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        .cart-modal .modal-body {
            max-height: 60vh;
            overflow-y: auto;
        }
        .menu-item-image {
            height: 200px;
            object-fit: cover;
            border-radius: 8px 8px 0 0;
        }
        .price-tag {
            font-size: 1.2rem;
            color: #2c3e50;
            font-weight: bold;
        }
        .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(44, 62, 80, 0.9);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
        .quantity-control {
            width: 120px;
        }
        .add-to-cart-btn {
            width: 100%;
            margin-top: 10px;
        }
        .menu-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Our Delicious Menu</h1>
        
        <!-- Cart Badge -->
        <div class="cart-badge">
            <button class="btn btn-primary position-relative" data-bs-toggle="modal" data-bs-target="#cartModal">
                <i class="fas fa-shopping-cart"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="cartCount">
                    0
                </span>
            </button>
        </div>

        <!-- Menu Items Display -->
        <div id="menuItems">
            <!-- Items will be loaded here dynamically -->
        </div>
    </div>

    <!-- Cart Modal -->
    <div class="modal fade" id="cartModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Your Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="cartItems">
                        <!-- Cart items will be displayed here -->
                    </div>
                    <div class="text-end mt-3">
                        <h5>Total: $<span id="cartTotal">0.00</span></h5>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Continue Shopping</button>
                    <button type="button" class="btn btn-primary" id="placeOrder">Place Order</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let cart = [];

        // Load menu items
        function loadMenuItems() {
            fetch('/api/menu-items')
                .then(response => response.json())
                .then(items => {
                    const menuItemsDiv = document.getElementById('menuItems');
                    menuItemsDiv.innerHTML = '';
                    
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
                            itemCard.className = 'col-md-4 mb-4';
                            itemCard.innerHTML = `
                                <div class="card menu-item-card">
                                    <div class="position-relative">
                                        <img src="https://source.unsplash.com/300x200/?food,${item.name}" 
                                             class="menu-item-image" alt="${item.name}">
                                        <span class="category-badge">${item.category}</span>
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title">${item.name}</h5>
                                        <p class="menu-description">
                                            Delicious ${item.name.toLowerCase()} from our ${item.category.toLowerCase()} menu.
                                        </p>
                                        <p class="price-tag">$${item.price.toFixed(2)}</p>
                                        <div class="d-flex flex-column align-items-center">
                                            <div class="input-group quantity-control">
                                                <button class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(${item.id}, -1)">-</button>
                                                <input type="number" class="form-control form-control-sm text-center" 
                                                       id="quantity-${item.id}" value="0" min="0" readonly>
                                                <button class="btn btn-outline-secondary btn-sm" onclick="updateQuantity(${item.id}, 1)">+</button>
                                            </div>
                                            <button class="btn btn-primary add-to-cart-btn" onclick="addToCart(${item.id})">
                                                <i class="fas fa-cart-plus"></i> Add to Cart
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            `;
                            categoryItemsDiv.appendChild(itemCard);
                        });
                    });
                })
                .catch(error => console.error('Error loading menu items:', error));
        }

        // Update quantity
        function updateQuantity(itemId, change) {
            const input = document.getElementById(`quantity-${itemId}`);
            const newValue = Math.max(0, parseInt(input.value) + change);
            input.value = newValue;
        }

        // Add to cart
        function addToCart(itemId) {
            const quantity = parseInt(document.getElementById(`quantity-${itemId}`).value);
            if (quantity <= 0) {
                alert('Please select a quantity first!');
                return;
            }

            fetch(`/api/menu-items/${itemId}`)
                .then(response => response.json())
                .then(item => {
                    const existingItem = cart.find(cartItem => cartItem.id === itemId);
                    if (existingItem) {
                        existingItem.quantity += quantity;
                    } else {
                        cart.push({
                            id: item.id,
                            name: item.name,
                            price: item.price,
                            quantity: quantity
                        });
                    }
                    document.getElementById(`quantity-${itemId}`).value = 0;
                    updateCartDisplay();
                    showAddedToCartMessage(item.name);
                })
                .catch(error => console.error('Error adding item to cart:', error));
        }

        // Show added to cart message
        function showAddedToCartMessage(itemName) {
            const toast = document.createElement('div');
            toast.className = 'position-fixed bottom-0 end-0 p-3';
            toast.style.zIndex = '5';
            toast.innerHTML = `
                <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <strong class="me-auto">Added to Cart</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${itemName} has been added to your cart!
                    </div>
                </div>
            `;
            document.body.appendChild(toast);
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }

        // Update cart display
        function updateCartDisplay() {
            const cartItemsDiv = document.getElementById('cartItems');
            const cartCount = document.getElementById('cartCount');
            const cartTotal = document.getElementById('cartTotal');
            
            cartItemsDiv.innerHTML = '';
            let total = 0;
            let count = 0;

            cart.forEach(item => {
                const itemTotal = item.price * item.quantity;
                total += itemTotal;
                count += item.quantity;

                const itemDiv = document.createElement('div');
                itemDiv.className = 'd-flex justify-content-between align-items-center mb-2';
                itemDiv.innerHTML = `
                    <div>
                        <h6 class="mb-0">${item.name}</h6>
                        <small class="text-muted">$${item.price.toFixed(2)} x ${item.quantity}</small>
                    </div>
                    <div>
                        <span class="me-2">$${itemTotal.toFixed(2)}</span>
                        <button class="btn btn-sm btn-danger" onclick="removeFromCart(${item.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                `;
                cartItemsDiv.appendChild(itemDiv);
            });

            cartCount.textContent = count;
            cartTotal.textContent = total.toFixed(2);
        }

        // Remove from cart
        function removeFromCart(itemId) {
            cart = cart.filter(item => item.id !== itemId);
            updateCartDisplay();
        }

        // Place order
        document.getElementById('placeOrder').addEventListener('click', function() {
            if (cart.length === 0) {
                alert('Your cart is empty!');
                return;
            }

            const order = {
                items: cart.map(item => ({
                    menuItemId: item.id,
                    quantity: item.quantity,
                    price: item.price
                }))
            };

            fetch('/api/orders', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(order)
            })
            .then(response => {
                if (response.ok) {
                    cart = [];
                    updateCartDisplay();
                    bootstrap.Modal.getInstance(document.getElementById('cartModal')).hide();
                    alert('Order placed successfully! Thank you for your order!');
                } else {
                    throw new Error('Failed to place order');
                }
            })
            .catch(error => {
                console.error('Error placing order:', error);
                alert('Failed to place order. Please try again.');
            });
        });

        // Load menu items when page loads
        document.addEventListener('DOMContentLoaded', loadMenuItems);
    </script>
</body>
</html> 