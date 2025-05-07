-- Create the database if it doesn't exist
IF DB_ID('restaurant') IS NULL
    CREATE DATABASE restaurant;
GO

-- Use the database
USE restaurant;
GO

-- Create users table
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Create menu_items table
CREATE TABLE menu_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'ACTIVE'
);

-- Create orders table
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    special_instructions VARCHAR(500),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create order_items table
CREATE TABLE order_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Create reservations table
CREATE TABLE reservations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    table_number INT NOT NULL,
    reservation_date DATETIME NOT NULL,
    party_size INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    special_requests VARCHAR(500),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes
CREATE INDEX idx_menu_items_category ON menu_items(category);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_date ON reservations(reservation_date);
CREATE INDEX idx_reservations_status ON reservations(status);

-- Insert sample data
INSERT INTO users (username, email, password, role, phone, status) VALUES
('admin', 'admin@restaurant.com', 'admin123', 'ADMIN', '1234567890', 'ACTIVE'),
('waiter', 'waiter@restaurant.com', 'waiter123', 'WAITER', '2345678901', 'ACTIVE'),
('chef', 'chef@restaurant.com', 'chef123', 'CHEF', '3456789012', 'ACTIVE');

INSERT INTO menu_items (name, description, price, category, status) VALUES
('Caesar Salad', 'Fresh romaine lettuce with Caesar dressing', 8.99, 'Appetizers', 'ACTIVE'),
('Garlic Bread', 'Toasted bread with garlic butter', 4.99, 'Appetizers', 'ACTIVE'),
('Margherita Pizza', 'Classic pizza with tomato and mozzarella', 12.99, 'Main Course', 'ACTIVE'),
('Spaghetti Carbonara', 'Pasta with creamy egg sauce and bacon', 14.99, 'Main Course', 'ACTIVE'),
('Chocolate Cake', 'Rich chocolate cake with ganache', 6.99, 'Desserts', 'ACTIVE'),
('Tiramisu', 'Classic Italian dessert with coffee', 7.99, 'Desserts', 'ACTIVE'),
('Cola', 'Refreshing carbonated drink', 2.99, 'Beverages', 'ACTIVE'),
('Mineral Water', 'Pure spring water', 1.99, 'Beverages', 'ACTIVE');

INSERT INTO orders (user_id, total, status, special_instructions) VALUES
(1, 24.98, 'PENDING', 'Less spicy please'),
(2, 14.99, 'COMPLETED', NULL),
(3, 7.99, 'CANCELLED', 'Allergic to peanuts');


INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES
(1, 3, 1, 12.99),
(1, 4, 1, 11.99),
(2, 6, 1, 7.99),
(2, 8, 1, 1.99),
(3, 5, 1, 6.99);


INSERT INTO reservations (user_id, table_number, reservation_date, party_size, status, special_requests) VALUES
(1, 5, '2025-05-10 19:00:00', 4, 'CONFIRMED', 'Near window'),
(2, 3, '2025-05-11 18:30:00', 2, 'COMPLETED', NULL),
(3, 1, '2025-05-12 20:00:00', 6, 'CANCELLED', 'Birthday celebration');

