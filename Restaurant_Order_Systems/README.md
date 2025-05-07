# Restaurant Order System

A comprehensive restaurant management system built with Java, Oracle Database, and modern web technologies.

## Features

- Menu Management
  - Add, edit, and delete menu items
  - Categorize items (Appetizers, Main Course, Desserts, Beverages)
  - Real-time price updates

- Order Processing
  - Create and manage orders
  - Track order status
  - Calculate totals automatically

- Table Reservations
  - Book tables
  - Manage party sizes
  - Track reservation status

- User Management
  - Role-based access control (Admin, Waiter, Chef)
  - Secure authentication
  - User profile management

## Technical Stack

- Backend:
  - Java 17
  - Jakarta EE
  - Oracle Database
  - HikariCP Connection Pool
  - Jackson for JSON processing
  - SLF4J for logging

- Frontend:
  - HTML5
  - CSS3 (Bootstrap 5)
  - JavaScript (ES6+)
  - Fetch API for AJAX

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── example/
│   │           └── restaurant/
│   │               ├── controller/    # Servlet controllers
│   │               ├── dao/           # Data Access Objects
│   │               ├── model/         # Entity classes
│   │               ├── service/       # Business logic
│   │               └── util/          # Utility classes
│   ├── resources/
│   │   └── db/                        # Database scripts
│   └── webapp/
│       ├── pages/                     # JSP pages
│       └── WEB-INF/                   # Web configuration
```

## Setup Instructions

1. Prerequisites:
   - Java 17 or higher
   - Oracle Database
   - Maven
   - Git

2. Database Setup:
   ```sql
   -- Run the initialization script
   @src/main/resources/db/init.sql
   ```

3. Configuration:
   - Update database connection settings in `DatabaseConfig.java`
   - Configure application properties in `web.xml`

4. Build and Run:
   ```bash
   mvn clean install
   mvn tomcat7:run
   ```

5. Access the application:
   - Open `http://localhost:8080/RestaurantOrderSystem`
   - Login with default credentials:
     - Admin: admin/admin123
     - Waiter: waiter/waiter123
     - Chef: chef/chef123

## API Documentation

### Menu Items API

- GET `/api/menu-items` - Get all menu items
- GET `/api/menu-items/{id}` - Get menu item by ID
- POST `/api/menu-items` - Create new menu item
- PUT `/api/menu-items/{id}` - Update menu item
- DELETE `/api/menu-items/{id}` - Delete menu item

### Orders API

- GET `/api/orders` - Get all orders
- GET `/api/orders/{id}` - Get order by ID
- POST `/api/orders` - Create new order
- PUT `/api/orders/{id}` - Update order status
- DELETE `/api/orders/{id}` - Cancel order

### Reservations API

- GET `/api/reservations` - Get all reservations
- GET `/api/reservations/{id}` - Get reservation by ID
- POST `/api/reservations` - Create new reservation
- PUT `/api/reservations/{id}` - Update reservation
- DELETE `/api/reservations/{id}` - Cancel reservation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- LaSalle College for the project requirements
- All contributors who have helped shape this project 